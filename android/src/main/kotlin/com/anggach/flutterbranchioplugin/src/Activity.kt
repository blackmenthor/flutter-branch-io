package com.anggach.flutterbranchioplugin.src

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.anggach.flutterbranchioplugin.FlutterBranchIoPlugin
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.EventChannel

open class FlutterBranchIOActivity : FlutterActivity(), EventChannel.StreamHandler {

    private var receiver: BroadcastReceiver? = null

    private fun setUpEventStream() {
        FlutterBranchIoPlugin.setUpStreamHandler(this)
    }

    private fun handleIntent(context: Context, intent: Intent?) {
        if (this.receiver != null && intent != null) receiver!!.onReceive(context, intent)
    }

    private fun createReceiver(events: EventChannel.EventSink): BroadcastReceiver {
        return object : BroadcastReceiver() {

            override fun onReceive(context: Context, intent: Intent) {
                events.success("ONSTART IS CALLED")
            }
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        receiver = createReceiver(events)
    }

    override fun onCancel(p0: Any?) {
        receiver = null
    }

    override fun onStart() {
        super.onStart()
        setUpEventStream()
        val intent = Intent()
        handleIntent(this, intent)
    }
}
