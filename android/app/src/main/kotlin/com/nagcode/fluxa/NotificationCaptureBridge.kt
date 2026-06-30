package com.nagcode.fluxa

import io.flutter.plugin.common.EventChannel

object NotificationCaptureBridge {
    const val prefsName = "fluxa_notification_capture"

    @Volatile
    var events: EventChannel.EventSink? = null

    fun emit(payload: Map<String, Any?>) {
        events?.success(payload)
    }
}
