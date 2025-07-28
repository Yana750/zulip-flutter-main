package com.zulip.flutter

import android.app.Activity
import android.content.Context
import android.content.ContextWrapper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

fun Context.findActivity(): Activity? = when (this) {
    is Activity -> this
    is ContextWrapper -> baseContext.findActivity()
    else -> null
}

class JitsiMeetViewFactory(
    private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val activity = context?.findActivity()
            ?: throw IllegalStateException("Could not find activity in context chain")
        val params = args as? Map<String, Any>
        val room = params?.get("room") as? String
        return JitsiMeetViewWrapper(activity, messenger, viewId, room)
    }
}
