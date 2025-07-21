package com.zulip.flutter

import android.os.Bundle
import android.content.Intent
import io.flutter.embedding.android.FlutterFragmentActivity
import org.jitsi.meet.sdk.JitsiMeetActivityDelegate
import org.jitsi.meet.sdk.JitsiMeetActivityInterface

class MainActivity : FlutterFragmentActivity(), JitsiMeetActivityInterface {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        JitsiMeetActivityDelegate.onCreate(this)
    }

    override fun onDestroy() {
        JitsiMeetActivityDelegate.onDestroy(this)
        super.onDestroy()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        JitsiMeetActivityDelegate.onActivityResult(this, requestCode, resultCode, data)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        JitsiMeetActivityDelegate.onNewIntent(intent)
    }

    override fun onBackPressed() {
        if (!JitsiMeetActivityDelegate.onBackPressed()) {
            super.onBackPressed()
        }
    }
}
