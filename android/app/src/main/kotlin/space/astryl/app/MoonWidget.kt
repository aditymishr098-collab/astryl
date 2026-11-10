package space.astryl.app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import kotlin.math.PI
import kotlin.math.cos
import kotlin.math.floor
import kotlin.math.roundToInt

/**
 * Home-screen widget: tonight's Moon phase, worked out on the phone from the
 * date alone (nothing is sent anywhere), and a tap opens Astryl for the Daily 5.
 */
class MoonWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (id in appWidgetIds) {
            appWidgetManager.updateAppWidget(id, build(context))
        }
    }

    companion object {
        private const val SYNODIC = 29.530588853
        private val EMOJI = arrayOf("🌑", "🌒", "🌓", "🌔", "🌕", "🌖", "🌗", "🌘")

        fun build(context: Context): RemoteViews {
            val jd = System.currentTimeMillis() / 86400000.0 + 2440587.5
            val age = (((jd - 2451550.1) % SYNODIC) + SYNODIC) % SYNODIC
            val fraction = age / SYNODIC
            val lit = ((1 - cos(2 * PI * fraction)) / 2 * 100).roundToInt()
            val index = floor(fraction * 8 + 0.5).toInt() % 8
            val names = context.resources.getStringArray(R.array.moon_phases)

            val views = RemoteViews(context.packageName, R.layout.moon_widget)
            views.setTextViewText(R.id.widget_moon, EMOJI[index])
            views.setTextViewText(
                R.id.widget_phase,
                names[index] + " · " + context.getString(R.string.widget_lit, lit),
            )
            val launch = context.packageManager.getLaunchIntentForPackage(context.packageName)
            if (launch != null) {
                val pending = PendingIntent.getActivity(
                    context,
                    0,
                    launch,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                )
                views.setOnClickPendingIntent(R.id.widget_root, pending)
            }
            return views
        }
    }
}
