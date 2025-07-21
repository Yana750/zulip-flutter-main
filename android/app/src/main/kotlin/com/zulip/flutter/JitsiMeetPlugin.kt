package com.zulip.flutter

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformViewRegistry

class JitsiMeetPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

    private var jitsiViewWrapper: JitsiMeetViewWrapper? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        flutterPluginBinding = binding
        channel = MethodChannel(binding.binaryMessenger, "jitsi_meet_plugin")
        channel.setMethodCallHandler(this)

        binding.platformViewRegistry.registerViewFactory(
            "jitsi_meet_view",
            JitsiMeetViewFactory(binding.binaryMessenger)
        )
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        jitsiViewWrapper = JitsiMeetViewWrapper(
            binding.activity,
            flutterPluginBinding.binaryMessenger,
            0, // id (можно улучшить, если будет несколько view)
            null // или начальная комната
        )
    }

    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {
        jitsiViewWrapper?.dispose()
        jitsiViewWrapper = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "joinRoom" -> {
                val room = call.argument<String>("room") ?: ""
                jitsiViewWrapper?.joinRoom(room)
                result.success(null)
            }
            "leaveRoom" -> {
                jitsiViewWrapper?.leaveRoom()
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
