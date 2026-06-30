package com.nagcode.fluxa

import android.content.Context
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val methodChannelName = "fluxa/notification_capture"
    private val eventChannelName = "fluxa/notification_capture/events"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            methodChannelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isEnabled" -> result.success(isNotificationListenerEnabled())
                "openSettings" -> {
                    startActivity(
                        Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    )
                    result.success(null)
                }
                "getLastNotification" -> result.success(readLastNotification())
                else -> result.notImplemented()
            }
        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            eventChannelName
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                NotificationCaptureBridge.events = events
            }

            override fun onCancel(arguments: Any?) {
                NotificationCaptureBridge.events = null
            }
        })
    }

    private fun isNotificationListenerEnabled(): Boolean {
        val enabledListeners = Settings.Secure.getString(
            contentResolver,
            "enabled_notification_listeners"
        ) ?: return false

        return enabledListeners
            .split(":")
            .any { it.contains(packageName, ignoreCase = true) }
    }

    private fun readLastNotification(): Map<String, Any?>? {
        val prefs = getSharedPreferences(NotificationCaptureBridge.prefsName, Context.MODE_PRIVATE)
        val id = prefs.getString("id", null) ?: return null

        return mapOf(
            "id" to id,
            "packageName" to prefs.getString("packageName", ""),
            "appName" to prefs.getString("appName", ""),
            "title" to prefs.getString("title", ""),
            "text" to prefs.getString("text", ""),
            "bigText" to prefs.getString("bigText", ""),
            "postTime" to prefs.getLong("postTime", 0L)
        )
    }
}
