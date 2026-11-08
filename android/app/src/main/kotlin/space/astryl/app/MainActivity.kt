package space.astryl.app

import android.Manifest
import android.content.ClipData
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "space.astryl.app/orientation"
        ).setStreamHandler(OrientationStream(this))
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "space.astryl.app/native"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "filesDir" -> result.success(filesDir.absolutePath)
                "updatesDir" -> {
                    val dir = java.io.File(cacheDir, "updates")
                    dir.mkdirs()
                    result.success(dir.absolutePath)
                }
                "installApk" -> result.success(installApk(call.argument<String>("path")))
                "sharedDir" -> {
                    val dir = java.io.File(cacheDir, "shared")
                    dir.mkdirs()
                    result.success(dir.absolutePath)
                }
                "shareImage" -> result.success(
                    shareImage(call.argument<String>("path"), call.argument<String>("text"))
                )
                "shareFile" -> result.success(
                    shareFile(
                        call.argument<String>("path"),
                        call.argument<String>("mime"),
                        call.argument<String>("text")
                    )
                )
                "pickBackup" -> pickBackup(result)
                "appVersion" -> result.success(appVersion())
                "openUrl" -> result.success(openUrl(call.argument<String>("url")))
                "requestNotifications" -> requestNotifications(result)
                "scheduleReminder" -> result.success(
                    Reminders.schedule(
                        this,
                        call.argument<String>("id") ?: "",
                        (call.argument<Number>("at") ?: 0).toLong(),
                        call.argument<String>("title") ?: "",
                        call.argument<String>("body") ?: "",
                        call.argument<String>("channel") ?: "Space events"
                    )
                )
                "cancelReminder" -> {
                    Reminders.cancel(this, call.argument<String>("id") ?: "")
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private var pendingNotificationResult: MethodChannel.Result? = null

    /** Asks for the notification permission on Android 13 and newer. */
    private fun requestNotifications(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < 33 ||
            checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            result.success(NotificationManagerCompat.from(this).areNotificationsEnabled())
            return
        }
        if (pendingNotificationResult != null) {
            result.success(false)
            return
        }
        pendingNotificationResult = result
        requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 4711)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 4711) {
            pendingNotificationResult?.success(
                grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
            )
            pendingNotificationResult = null
        }
    }

    /** Returns "ok", "permission" (the user must allow installs) or "error". */
    private fun installApk(path: String?): String {
        if (path == null) {
            return "error"
        }
        val file = java.io.File(path)
        if (!file.exists()) {
            return "error"
        }
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
                !packageManager.canRequestPackageInstalls()
            ) {
                startActivity(
                    Intent(
                        Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                        Uri.parse("package:$packageName")
                    )
                )
                "permission"
            } else {
                val uri = FileProvider.getUriForFile(
                    this,
                    "$packageName.fileprovider",
                    file
                )
                val intent = Intent(Intent.ACTION_VIEW)
                    .setDataAndType(uri, "application/vnd.android.package-archive")
                    .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
                "ok"
            }
        } catch (e: Exception) {
            "error"
        }
    }

    /** Opens the Android share sheet with a PNG and a line of text. */
    private fun shareImage(path: String?, text: String?): Boolean {
        return shareFile(path, "image/png", text)
    }

    /** Opens the Android share sheet with a file of type [mime] and a line of text. */
    private fun shareFile(path: String?, mime: String?, text: String?): Boolean {
        if (path == null) {
            return false
        }
        val file = java.io.File(path)
        if (!file.exists()) {
            return false
        }
        return try {
            val uri = FileProvider.getUriForFile(this, "$packageName.fileprovider", file)
            val send = Intent(Intent.ACTION_SEND)
                .setType(mime ?: "application/octet-stream")
                .putExtra(Intent.EXTRA_STREAM, uri)
                .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            if (text != null) {
                send.putExtra(Intent.EXTRA_TEXT, text)
            }
            send.clipData = ClipData.newRawUri(null, uri)
            startActivity(Intent.createChooser(send, null))
            true
        } catch (e: Exception) {
            false
        }
    }

    private var pendingPickResult: MethodChannel.Result? = null

    /** Lets the user pick a backup file and returns its text, or null. */
    private fun pickBackup(result: MethodChannel.Result) {
        if (pendingPickResult != null) {
            result.success(null)
            return
        }
        try {
            val intent = Intent(Intent.ACTION_OPEN_DOCUMENT)
                .addCategory(Intent.CATEGORY_OPENABLE)
                .setType("*/*")
            pendingPickResult = result
            startActivityForResult(intent, 4712)
        } catch (e: Exception) {
            pendingPickResult = null
            result.success(null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 4712) {
            val uri = if (resultCode == android.app.Activity.RESULT_OK) data?.data else null
            pendingPickResult?.success(if (uri == null) null else readText(uri))
            pendingPickResult = null
        }
    }

    /** Reads a small text file; null when it cannot be read or is too big. */
    private fun readText(uri: Uri): String? {
        return try {
            contentResolver.openInputStream(uri)?.use { input ->
                val out = java.io.ByteArrayOutputStream()
                val buffer = ByteArray(8192)
                var total = 0
                var tooBig = false
                while (true) {
                    val n = input.read(buffer)
                    if (n < 0) {
                        break
                    }
                    total += n
                    if (total > 524288) {
                        tooBig = true
                        break
                    }
                    out.write(buffer, 0, n)
                }
                if (tooBig) null else out.toString("UTF-8")
            }
        } catch (e: Exception) {
            null
        }
    }

    private fun appVersion(): String {
        return try {
            packageManager.getPackageInfo(packageName, 0).versionName ?: ""
        } catch (e: Exception) {
            ""
        }
    }

    private fun openUrl(url: String?): Boolean {
        if (url == null || !url.startsWith("https://")) {
            return false
        }
        return try {
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
            true
        } catch (e: Exception) {
            false
        }
    }
}
