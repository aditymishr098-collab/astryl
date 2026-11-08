package space.astryl.app

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import org.json.JSONObject

/**
 * Reminders for space events. Each one is an Android alarm plus a small
 * record in private storage, so the alarms can be set again after a restart
 * or an app update. Nothing leaves the phone.
 */
object Reminders {
    private const val PREFS = "reminders"
    private const val CHANNEL = "space_events"

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    private fun pendingIntent(context: Context, id: String): PendingIntent {
        val intent = Intent(context, ReminderReceiver::class.java)
            .setAction("space.astryl.app.REMINDER.$id")
            .putExtra("id", id)
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)
        return PendingIntent.getBroadcast(context, id.hashCode(), intent, flags)
    }

    private fun setAlarm(context: Context, id: String, atMs: Long) {
        val alarms = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        // Not exact on purpose: no special permission is needed, and a
        // reminder a few minutes late does no harm.
        alarms.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, atMs, pendingIntent(context, id))
    }

    fun schedule(
        context: Context,
        id: String,
        atMs: Long,
        title: String,
        body: String,
        channel: String
    ): Boolean {
        if (atMs <= System.currentTimeMillis()) {
            return false
        }
        return try {
            val record = JSONObject()
                .put("at", atMs)
                .put("title", title)
                .put("body", body)
                .put("channel", channel)
            prefs(context).edit().putString(id, record.toString()).apply()
            setAlarm(context, id, atMs)
            true
        } catch (e: Exception) {
            false
        }
    }

    fun cancel(context: Context, id: String) {
        try {
            val alarms = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            alarms.cancel(pendingIntent(context, id))
        } catch (e: Exception) {
            // Nothing to cancel.
        }
        prefs(context).edit().remove(id).apply()
    }

    /** Sets every saved reminder again. Called after a restart or an update. */
    fun rescheduleAll(context: Context) {
        val now = System.currentTimeMillis()
        val store = prefs(context)
        for ((id, value) in store.all) {
            try {
                val record = JSONObject(value as String)
                val at = record.getLong("at")
                if (at > now) {
                    setAlarm(context, id, at)
                } else {
                    store.edit().remove(id).apply()
                }
            } catch (e: Exception) {
                store.edit().remove(id).apply()
            }
        }
    }

    fun show(context: Context, id: String) {
        val store = prefs(context)
        val value = store.getString(id, null) ?: return
        store.edit().remove(id).apply()
        try {
            val record = JSONObject(value)
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                manager.createNotificationChannel(
                    NotificationChannel(
                        CHANNEL,
                        record.optString("channel", "Space events"),
                        NotificationManager.IMPORTANCE_DEFAULT
                    )
                )
            }
            val open = context.packageManager.getLaunchIntentForPackage(context.packageName)
            val flags = PendingIntent.FLAG_UPDATE_CURRENT or
                (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_IMMUTABLE else 0)
            val tap = PendingIntent.getActivity(context, id.hashCode(), open, flags)
            val icon = context.resources.getIdentifier("ic_stat_heliora", "drawable", context.packageName)
            val notification = NotificationCompat.Builder(context, CHANNEL)
                .setSmallIcon(if (icon != 0) icon else android.R.drawable.star_on)
                .setContentTitle(record.getString("title"))
                .setContentText(record.getString("body"))
                .setStyle(NotificationCompat.BigTextStyle().bigText(record.getString("body")))
                .setContentIntent(tap)
                .setAutoCancel(true)
                .build()
            manager.notify(id.hashCode(), notification)
        } catch (e: Exception) {
            // A reminder that cannot be shown is dropped.
        }
    }
}

/** Shows a reminder when its alarm goes off. */
class ReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val id = intent.getStringExtra("id") ?: return
        Reminders.show(context, id)
    }
}

/** Sets the alarms again after a restart or after the app was updated. */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // Only the two system broadcasts this receiver is for; anything else
        // is ignored.
        if (intent.action == Intent.ACTION_BOOT_COMPLETED ||
            intent.action == Intent.ACTION_MY_PACKAGE_REPLACED
        ) {
            Reminders.rescheduleAll(context)
        }
    }
}
