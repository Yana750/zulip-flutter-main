// JitsiMeetViewWrapper.kt
package com.zulip.flutter

import android.app.Activity
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView
import org.jitsi.meet.sdk.JitsiMeetConferenceOptions
import org.jitsi.meet.sdk.JitsiMeetView
import java.net.URL

class JitsiMeetViewWrapper(
    private val activity: Activity,
    messenger: BinaryMessenger,
    id: Int,
    private val roomName: String?
) : PlatformView, MethodCallHandler {

    private val jitsiView = JitsiMeetView(activity)

    init {
        MethodChannel(messenger, "jitsi_meet_view_$id").setMethodCallHandler(this)

        roomName?.let { room -> joinRoom(room) }
    }

    override fun getView(): View = jitsiView

    override fun dispose() {
        jitsiView.dispose()
    }

    fun joinRoom(room: String) {
        val options = JitsiMeetConferenceOptions.Builder()
            .setServerURL(URL("https://jitsi-connectrm.ru"))
            .setRoom(room)
            .setAudioMuted(false)
            .setVideoMuted(false)
            .build()
        jitsiView.join(options)
    }

    fun leaveRoom() {
        jitsiView.dispose()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "joinRoom" -> {
                val room = call.argument<String>("room")
                if (room != null) {
                    joinRoom(room)
                    result.success(null)
                } else {
                    result.error("ROOM_ERROR", "Room is null", null)
                }
            }
            "leaveRoom" -> {
                leaveRoom()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }
}
