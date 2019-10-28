package com.anggach.flutterbranchioplugin

import com.anggach.flutterbranchioplugin.src.*
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

const val DEBUG_NAME = "FlutterBranchIo"
const val INTENT_EXTRA_DATA = "DATA"

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

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "initBranchIO" -> {
                setUpBranchIo(registrar, deepLinkStreamHandler, result)
            }
            call.method == "generateLink" -> {
                generateLinkHandler(this.registrar, generatedLinkStreamHandler, call)
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
                listOnGoogleSearch(this.registrar, call)
                result.success("List on google search success")
            }
            call.method == "trackContent" -> {
                trackContent(this.registrar, call)
                result.success("Track event success")
            }
            call.method == "setUserIdentity" -> {
                setUserID(call)
                result.success("set User Identity success")
            }
            call.method == "clearUserIdentity" -> {
                clearUserID()
                result.success("clear User Identity Success")
            }
            else -> result.notImplemented()
        }
    }
}
