package space.astryl.app

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL

/**
 * Looks for new announcements from the Astryl team about every six hours and
 * shows each one as a notification. The only thing sent is the question "what
 * is new?" to the project's own Supabase function; nothing about the phone or
 * the person is sent. The first check on a phone only notes what already
 * exists, so nobody gets old news.
 */
object NewsCheck {
    private const val PREFS = "news"
    private const val CHANNEL = "astryl_news"
    private const val EVERY_MS = 6L * 60 * 60 * 1000

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    private fun pending(context: Context): PendingIntent {
        val intent = Intent(context, NewsReceiver::class.java)
            .setAction("space.astryl.app.NEWS_CHECK")
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)
        return PendingIntent.getBroadcast(context, 7301, intent, flags)
    }

    /** Called each time the app opens: saves the settings, plans the next check and checks now. */
    fun configure(context: Context, on: Boolean, url: String, key: String, lang: String) {
        if (!on) {
            cancel(context)
            prefs(context).edit().putBoolean("on", false).apply()
            return
        }
        prefs(context).edit()
            .putBoolean("on", true)
            .putString("url", url)
            .putString("key", key)
            .putString("lang", lang)
            .apply()
        schedule(context)
        checkNow(context, null)
    }

    fun schedule(context: Context) {
        try {
            val alarms = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            alarms.setAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                System.currentTimeMillis() + EVERY_MS,
                pending(context)
            )
        } catch (e: Exception) {
            // Tried again the next time the app opens.
        }
    }

    fun cancel(context: Context) {
        try {
            val alarms = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            alarms.cancel(pending(context))
        } catch (e: Exception) {
            // Nothing to cancel.
        }
    }

    fun rescheduleIfOn(context: Context) {
        if (prefs(context).getBoolean("on", false)) {
            schedule(context)
        }
    }

    fun checkNow(context: Context, done: (() -> Unit)?) {
        val app = context.applicationContext
        Thread {
            try {
                run(app)
            } catch (e: Throwable) {
                // Offline or a bad answer: the next check tries again.
            } finally {
                done?.invoke()
            }
        }.start()
    }

    /** A text field, or an empty text when it is missing or null. */
    private fun textOf(item: JSONObject, name: String): String =
        if (item.isNull(name)) "" else item.optString(name, "")

    private fun run(context: Context) {
        val store = prefs(context)
        if (!store.getBoolean("on", false)) {
            return
        }
        val address = store.getString("url", "") ?: ""
        val key = store.getString("key", "") ?: ""
        if (!address.startsWith("https://")) {
            return
        }
        val hindi = store.getString("lang", "en") == "hi"
        val conn = URL(address).openConnection() as HttpURLConnection
        val text: String
        try {
            conn.requestMethod = "POST"
            conn.connectTimeout = 15000
            conn.readTimeout = 15000
            conn.doOutput = true
            conn.setRequestProperty("Content-Type", "application/json")
            conn.setRequestProperty("apikey", key)
            conn.outputStream.use { it.write("{\"action\":\"news\"}".toByteArray(Charsets.UTF_8)) }
            if (conn.responseCode != 200) {
                return
            }
            text = conn.inputStream.bufferedReader().use { it.readText().take(65536) }
        } finally {
            conn.disconnect()
        }
        val items = JSONObject(text).optJSONArray("items") ?: return
        val fresh = ArrayList<JSONObject>()
        var maxId = 0L
        for (i in 0 until items.length()) {
            val item = items.getJSONObject(i)
            fresh.add(item)
            maxId = Math.max(maxId, item.getLong("id"))
        }
        val last = store.getLong("last", -1L)
        if (last < 0) {
            store.edit().putLong("last", maxId).apply()
            return
        }
        // Oldest first, at most three at once.
        fresh.sortBy { it.getLong("id") }
        val news = fresh.filter { it.getLong("id") > last }.takeLast(3)
        for (item in news) {
            val title = (if (hindi) textOf(item, "title_hi") else "").ifEmpty { textOf(item, "title_en") }
            val body = (if (hindi) textOf(item, "body_hi") else "").ifEmpty { textOf(item, "body_en") }
            if (title.isNotEmpty() && body.isNotEmpty()) {
                Reminders.post(context, "news:" + item.getLong("id"), title, body, CHANNEL, "Astryl news")
            }
        }
        if (maxId > last) {
            store.edit().putLong("last", maxId).apply()
        }
    }
}

/** Runs the check when its alarm goes off, then plans the next one. */
class NewsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val waiting = goAsync()
        NewsCheck.checkNow(context) {
            NewsCheck.schedule(context)
            waiting.finish()
        }
    }
}
