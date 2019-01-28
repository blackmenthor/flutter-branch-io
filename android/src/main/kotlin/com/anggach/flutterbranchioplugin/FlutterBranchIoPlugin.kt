package com.anggach.flutterbranchioplugin

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.branch.indexing.BranchUniversalObject
import io.branch.referral.Branch
import io.branch.referral.BranchError
import io.branch.referral.BranchUtil
import io.branch.referral.util.ContentMetadata
import io.branch.referral.util.CurrencyType
import io.branch.referral.util.ProductCategory
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.json.JSONObject
import java.util.*

const val DEBUG_NAME = "FlutterBranchIo"
const val INTENT_EXTRA_DATA = "DATA"

class FlutterBranchIoPlugin(var registrar: Registrar) : MethodCallHandler, EventChannel.StreamHandler {

    private var receiver: BroadcastReceiver? = null

    companion object {
        private const val MESSAGE_CHANNEL: String = "flutter_branch_io/message"
        private const val EVENT_CHANNEL: String = "flutter_branch_io/event"
        private const val ON_START_CHANNEL: String = "flutter_branch_io/on_start"

        private lateinit var eventChannel: EventChannel
        private lateinit var onStartChannel: EventChannel

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            if (registrar.activity() == null) return

            val instance = FlutterBranchIoPlugin(registrar)

            val messageChannel = MethodChannel(registrar.messenger(), MESSAGE_CHANNEL)
            messageChannel.setMethodCallHandler(instance)
            eventChannel = EventChannel(registrar.messenger(), EVENT_CHANNEL)
            eventChannel.setStreamHandler(instance)

            onStartChannel = EventChannel(registrar.messenger(), ON_START_CHANNEL)
        }

        fun setUpStreamHandler(handler: EventChannel.StreamHandler) {
            this.onStartChannel.setStreamHandler(handler)
        }
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
                handleIntent(this.registrar.activity(), intent)
            } else {
                Log.i(DEBUG_NAME, error.message)
            }
        }, this.registrar.activity().intent.data, this.registrar.activity())

    }

    private fun handleIntent(context: Context, intent: Intent?) {
        if (this.receiver != null && intent != null) receiver!!.onReceive(context, intent)
    }

    private fun createReceiver(events: EventSink): BroadcastReceiver {
        return object : BroadcastReceiver() {

            override fun onReceive(context: Context, intent: Intent) {

                val dataString = intent.getStringExtra(INTENT_EXTRA_DATA)
                Log.d(DEBUG_NAME, "NEW BRANCH DATA $dataString")
                if (dataString == null) {
                    events.error("UNAVAILABLE", "Link unavailable", null)
                } else {
                    events.success(dataString)
                }
            }
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        receiver = createReceiver(events)
    }

    override fun onCancel(p0: Any?) {
        receiver = null
    }

    fun getBUOJSON(): String {
        try {
            val calendar = Calendar.getInstance()
            val today = calendar.time
            calendar.add(Calendar.DAY_OF_YEAR, 1)
            val tomorrow = calendar.time
            val buo: BranchUniversalObject =
                    BranchUniversalObject()
//                            .setCanonicalIdentifier("DUMMY CANONICAL IDENTIFIER")
//                            .setCanonicalUrl("DUMMY CANONICAL URL")
//                            .setTitle("DUMMY TITLE")
//                            .setContentDescription("DUMMY CONTENT DESCRIPTION")
//                            .setContentImageUrl("DUMMY IMAGE URL")
                            .setContentMetadata(
                                    ContentMetadata()
                                            .setQuantity(1.0)
                                            .setPrice(1.0, CurrencyType.IDR)
                                            .setSku("DUMMY SKU")
                                            .setProductName("DUMMY PRODUCT NAME")
                                            .setProductBrand("DUMMY PRODUCT BRAND")
                                            .setProductCategory(ProductCategory.HOME_AND_GARDEN)
                                            .setProductCondition(ContentMetadata.CONDITION.EXCELLENT)
                                            .setProductVariant("DUMMY PRODUCT VARIANT")
                                            .setAddress("STREET", "CITY", "REGION", "COUNTRY", "POSTALCODE")
                                            .setLocation(100.1, 100.1)
                                            .addImageCaptions("CAPTION1", "CAPTION2", "CAPTION3")
//                                            .addCustomMetadata("DUMMYKEY", "DUMMYVALUE")
                            )
//                            .setContentIndexingMode(BranchUniversalObject.CONTENT_INDEX_MODE.PRIVATE)
//                            .addKeyWords(arrayListOf("DUMMY KEYWORD 1", "DUMMY KEYWORD 2", "DUMMY KEYWORD 3"))
//                            .setContentExpiration(tomorrow)
//                            .setLocalIndexMode(BranchUniversalObject.CONTENT_INDEX_MODE.PRIVATE)
            return buo.convertToJson().toString()
        } catch (e: Exception) {
            return ""
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "initBranchIO") {
            result.success("INITIALIZING BRANCH IO")
            setUpBranchIo()
        } else if (call.method == "getBUOJSON") {
            val json = getBUOJSON()
            result.success(json)
        } else {
            result.notImplemented()
        }
    }
}
