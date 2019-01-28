package com.anggach.flutterbranchioplugin

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.branch.indexing.BranchUniversalObject
import io.branch.referral.Branch
import io.branch.referral.BranchError
import io.branch.referral.BranchUtil
import io.branch.referral.util.BranchEvent
import io.branch.referral.util.LinkProperties
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.json.JSONObject

const val DEBUG_NAME = "FlutterBranchIo"
const val INTENT_EXTRA_DATA = "DATA"

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
        Log.d(DEBUG_NAME, "ON LIstEN")
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

class FlutterBranchIoPlugin(private var registrar: Registrar) : MethodCallHandler {

    companion object {
        private const val MESSAGE_CHANNEL: String = "flutter_branch_io/message"
        private const val EVENT_CHANNEL: String = "flutter_branch_io/event"
        private const val GENERATED_LINK_CHANNEL: String = "flutter_branch_io/generated_link"

        private var generatedLinkStreamHandler: GeneratedLinkStreamHandler? = null
        private var deepLinkStreamHandler: DeepLinkStreamHandler? = null

        private lateinit var eventChannel: EventChannel
        private lateinit var generatedLinkChannel: EventChannel

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            if (registrar.activity() == null) return

            val instance = FlutterBranchIoPlugin(registrar)

            val messageChannel = MethodChannel(registrar.messenger(), MESSAGE_CHANNEL)
            messageChannel.setMethodCallHandler(instance)
            eventChannel = EventChannel(registrar.messenger(), EVENT_CHANNEL)
            this.deepLinkStreamHandler = this.deepLinkStreamHandler ?: DeepLinkStreamHandler()
            eventChannel.setStreamHandler(this.deepLinkStreamHandler)

            generatedLinkChannel = EventChannel(registrar.messenger(), GENERATED_LINK_CHANNEL)
            this.generatedLinkStreamHandler = this.generatedLinkStreamHandler ?: GeneratedLinkStreamHandler()
            generatedLinkChannel.setStreamHandler(this.generatedLinkStreamHandler)
        }

    }

    private fun errorGeneratedLink(error: BranchError) {
        val intent = Intent()
        intent.putExtra("error", error.toString())
        Companion.generatedLinkStreamHandler!!.handleIntent(this.registrar.context(), intent)
    }

    private fun sendGeneratedLink(link: String?) {
        val intent = Intent()
        if (link == null) return
        intent.putExtra("link", link)
        Companion.generatedLinkStreamHandler!!.handleIntent(this.registrar.context(), intent)
    }

    private fun init() {
        if (!BranchUtil.isTestModeEnabled(registrar.activity().applicationContext)) {
            Branch.getInstance(registrar.activity().applicationContext)
        } else {
            Branch.getTestInstance(registrar.activity().applicationContext)
        }

        // Branch logging for debugging
        Branch.enableLogging()

        // Branch object initialization
        Branch.getAutoInstance(registrar.activity().applicationContext)
    }

    private fun setUpBranchIo() {
        init()
        Branch.getInstance().initSession({ referringParams: JSONObject?, error: BranchError? ->
            Log.d(DEBUG_NAME, "BRANCH CALLBACK")
            if (error == null) {
                val params = referringParams?.toString()
                val intent = Intent()
                intent.putExtra(INTENT_EXTRA_DATA, params)
                Companion.deepLinkStreamHandler!!.handleIntent(this.registrar.activity(), intent)
            } else {
                Log.i(DEBUG_NAME, error.message)
            }
        }, this.registrar.activity().intent.data, this.registrar.activity())

    }

    private fun generateLink(buo: BranchUniversalObject, lp: LinkProperties) {
        buo.generateShortUrl(this.registrar.activeContext(), lp, {
            link, error -> if (error == null) sendGeneratedLink(link) else errorGeneratedLink(error)
        })
    }

    private fun getBranchLatestParam(): String {
        val params = Branch.getInstance().latestReferringParams
        if (params != null)
            return params.toString()
        return ""
    }

    private fun getBranchFirstParam(): String {
        val params = Branch.getInstance().firstReferringParams
        if (params != null)
            return params.toString()
        return ""
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "initBranchIO" -> {
                result.success("INITIALIZING BRANCH IO")
                setUpBranchIo()
            }
            call.method == "generateLink" -> {
                val buoJson = JSONObject(call.argument<String>("buoJson"))
                val buo = BranchUniversalObject.createInstance(buoJson)
                val lp = LinkProperties()
                val channel = call.argument<String>("lp_channel")
                if (channel != null) lp.channel = channel
                val feature = call.argument<String>("lp_feature")
                if (feature != null) lp.feature = feature
                val campaign = call.argument<String>("lp_campaign")
                if (campaign != null) lp.campaign = campaign
                val stage = call.argument<String>("lp_stage")
                if (stage != null) lp.stage = stage
                call.argument<Map<String, String>>("lp_control_params")?.forEach { t, u -> lp.addControlParameter(t, u) }
                generateLink(buo, lp)
                result.success("Generate link success")
            }
            call.method == "getLatestParam" -> {
                val param = getBranchLatestParam()
                result.success(param)
            }
            call.method == "getFirstParam" -> {
                val param = getBranchFirstParam()
                result.success(param)
            }
            call.method == "listOnGoogleSearch" -> {
                val buoJson = JSONObject(call.argument<String>("buoJson"))
                val buo = BranchUniversalObject.createInstance(buoJson)
                val lp = LinkProperties()
                val channel = call.argument<String>("lp_channel")
                if (channel != null) lp.channel = channel
                val feature = call.argument<String>("lp_feature")
                if (feature != null) lp.feature = feature
                val campaign = call.argument<String>("lp_campaign")
                if (campaign != null) lp.campaign = campaign
                val stage = call.argument<String>("lp_stage")
                if (stage != null) lp.stage = stage
                call.argument<Map<String, String>>("lp_control_params")?.forEach { t, u -> lp.addControlParameter(t, u) }
                buo.listOnGoogleSearch(this.registrar.activeContext(), lp)
                result.success("List on google search success")
            }
            call.method == "trackContent" -> {
                val buoJson = JSONObject(call.argument<String>("buoJson"))
                val buo = BranchUniversalObject.createInstance(buoJson)
                val eventType = call.argument<String>("eventType")
                BranchEvent(eventType).addContentItems(buo).logEvent(this.registrar.activeContext())
                result.success("Track event success")
            }
            call.method == "setUserIdentity" -> {
                val userId = call.argument<String>("userId")
                Branch.getInstance().setIdentity(userId ?: "")
            }
            call.method == "clearUserIdentity" -> {
                Branch.getInstance().logout()
            }
            else -> result.notImplemented()
        }
    }
}
