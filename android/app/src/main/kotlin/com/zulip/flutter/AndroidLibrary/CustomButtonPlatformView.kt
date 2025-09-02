package com.zulip.flutter

import android.content.Context
import android.view.View
import com.example.custombuttonlib.CustomButtonView
import io.flutter.plugin.platform.PlatformView

class CustomButtonPlatformView(
    context: Context,
    id: Int,
    args: Map<String, Any>?
) : PlatformView {

    private val buttonView: CustomButtonView = CustomButtonView(context)

    init {
        val color = args?.get("color") as? String ?: "#FF6200EE"
        val radius = (args?.get("radius") as? Double)?.toFloat() ?: 24f
        val label = args?.get("label") as? String ?: "Default"

        buttonView.setButtonColor(color)
        buttonView.setCornerRadius(radius)
        buttonView.setLabel(label)
    }
    override fun getView(): View = buttonView
    override fun dispose() {}
}
