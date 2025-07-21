// JitsiMeetViewFactory.kt
package com.zulip.flutter

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class JitsiMeetViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val activity = context as? Activity
            ?: throw IllegalStateException("Context is not an Activity")

        val creationParams = args as? Map<String, Any>
        val room = creationParams?.get("room") as? String
        return JitsiMeetViewWrapper(activity, messenger, viewId, room)
    }
}
