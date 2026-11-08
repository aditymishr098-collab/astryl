package space.astryl.app

import android.content.Context
import android.hardware.GeomagneticField
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel
import kotlin.math.asin
import kotlin.math.atan2

/**
 * Streams where the back of the phone points: [azimuth from true north,
 * altitude above the horizon, sensor accuracy 0..3]. Uses the rotation
 * vector sensor (compass + motion sensors). No camera, no location.
 */
class OrientationStream(private val context: Context) : EventChannel.StreamHandler {
    private var manager: SensorManager? = null
    private var listener: SensorEventListener? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        val sm = context.getSystemService(Context.SENSOR_SERVICE) as? SensorManager
        val sensor = sm?.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR)
        if (sm == null || sensor == null) {
            events.error("nosensor", "No rotation vector sensor", null)
            return
        }
        val args = arguments as? Map<*, *>
        val lat = (args?.get("lat") as? Number)?.toFloat() ?: 0f
        val lon = (args?.get("lon") as? Number)?.toFloat() ?: 0f
        // Compass north is magnetic north; this turns it into true north.
        val declination = GeomagneticField(lat, lon, 0f, System.currentTimeMillis()).declination

        val r = FloatArray(9)
        var accuracy = SensorManager.SENSOR_STATUS_ACCURACY_HIGH
        val l = object : SensorEventListener {
            override fun onSensorChanged(event: SensorEvent) {
                SensorManager.getRotationMatrixFromVector(r, event.values)
                // World axes: x east, y north, z up. The back of the phone is
                // the device's -z axis, so take minus the third column.
                val x = -r[2].toDouble()
                val y = -r[5].toDouble()
                val z = (-r[8].toDouble()).coerceIn(-1.0, 1.0)
                var az = Math.toDegrees(atan2(x, y)) + declination
                az = ((az % 360.0) + 360.0) % 360.0
                val alt = Math.toDegrees(asin(z))
                events.success(listOf(az, alt, accuracy))
            }

            override fun onAccuracyChanged(s: Sensor, a: Int) {
                accuracy = a
            }
        }
        manager = sm
        listener = l
        sm.registerListener(l, sensor, SensorManager.SENSOR_DELAY_GAME)
    }

    override fun onCancel(arguments: Any?) {
        val l = listener
        if (l != null) {
            manager?.unregisterListener(l)
        }
        listener = null
        manager = null
    }
}
