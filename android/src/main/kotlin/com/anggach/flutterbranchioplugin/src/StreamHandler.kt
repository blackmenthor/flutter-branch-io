package com.anggach.flutterbranchioplugin.src

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.anggach.flutterbranchioplugin.DEBUG_NAME
import com.anggach.flutterbranchioplugin.INTENT_EXTRA_DATA
import io.flutter.plugin.common.EventChannel

class GeneratedLinkStreamHandler: EventChannel.StreamHandler {

    private var receiver: BroadcastReceiver? = null

    fun handleIntent(context: Context, intent: Intent?) {
        if (this.receiver != null && intent != null) receiver!!.onReceive(context, intent)
    }

    override fun onCancel(p0: Any?) {
        receiver = null
    }

    override fun onListen(p0: Any?, events: EventChannel.EventSink?) {
        receiver = createReceiver(events)
    }

    private fun createReceiver(events: EventChannel.EventSink?): BroadcastReceiver {
        return object : BroadcastReceiver() {

            override fun onReceive(context: Context, intent: Intent) {
                val link = intent.getStringExtra("link")
                if (link != null)
                    events!!.success(link)
                else {
                    val error = intent.getStringExtra("error")
                    events!!.error(error, "", "")
                }
            }
        }
    }

}

class DeepLinkStreamHandler: EventChannel.StreamHandler {

    private var receiver: BroadcastReceiver? = null

    fun handleIntent(context: Context, intent: Intent?) {
        if (this.receiver != null && intent != null) receiver!!.onReceive(context, intent)
    }

    override fun onCancel(p0: Any?) {
        receiver = null
    }

    override fun onListen(p0: Any?, events: EventChannel.EventSink?) {
        Log.d(DEBUG_NAME, "ON LISTEN")
        receiver = createReceiver(events)
    }

    private fun createReceiver(events: EventChannel.EventSink?): BroadcastReceiver {
        return object : BroadcastReceiver() {

            override fun onReceive(context: Context, intent: Intent) {
                val dataString = intent.getStringExtra(INTENT_EXTRA_DATA)
                Log.d(DEBUG_NAME, "NEW BRANCH DATA $dataString")
                if (dataString == null) {
                    events!!.error("UNAVAILABLE", "Link unavailable", null)
                } else {
                    events!!.success(dataString)
                }
            }
        }
    }

}