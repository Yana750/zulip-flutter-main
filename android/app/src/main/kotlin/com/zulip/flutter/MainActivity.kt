package com.zulip.flutter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ✅ Регистрируем кастомный вью
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("custom_button_view", CustomButtonFactory())
    }
}
