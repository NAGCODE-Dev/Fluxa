package com.nagcode.fluxa

import android.app.Notification
import android.content.Context
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification

class FluxaNotificationListenerService : NotificationListenerService() {
    private val moneyPattern = Regex(
        pattern = "(?i)(R\\$|RS\\$?|BRL)\\s*\\d[\\d.]*,\\d{2}"
    )

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        val posted = sbn ?: return
        val notification = posted.notification ?: return
        val extras = notification.extras ?: return

        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString().orEmpty()
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString().orEmpty()
        val bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString().orEmpty()
        val lines = extras
            .getCharSequenceArray(Notification.EXTRA_TEXT_LINES)
            ?.joinToString(" ") { it.toString() }
            .orEmpty()
        val combined = listOf(title, text, bigText, lines)
            .filter { it.isNotBlank() }
            .joinToString(" ")

        if (!moneyPattern.containsMatchIn(combined)) {
            return
        }

        val id = "${posted.packageName}|${posted.postTime}|${combined.hashCode()}"
        val prefs = getSharedPreferences(NotificationCaptureBridge.prefsName, Context.MODE_PRIVATE)
        if (prefs.getString("id", null) == id) {
            return
        }

        val payload = mapOf(
            "id" to id,
            "packageName" to posted.packageName,
            "appName" to resolveAppName(posted.packageName),
            "title" to title,
            "text" to text,
            "bigText" to bigText.ifBlank { lines },
            "postTime" to posted.postTime
        )

        prefs.edit()
            .putString("id", id)
            .putString("packageName", posted.packageName)
            .putString("appName", payload["appName"] as String)
            .putString("title", title)
            .putString("text", text)
            .putString("bigText", payload["bigText"] as String)
            .putLong("postTime", posted.postTime)
            .apply()

        NotificationCaptureBridge.emit(payload)
    }

    private fun resolveAppName(packageName: String): String {
        return runCatching {
            val appInfo = packageManager.getApplicationInfo(packageName, 0)
            packageManager.getApplicationLabel(appInfo).toString()
        }.getOrDefault(packageName)
    }
}
