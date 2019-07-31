package com.anggach.flutterbranchioplugin.src

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.anggach.flutterbranchioplugin.FlutterBranchIoPlugin
import io.branch.indexing.BranchUniversalObject
import io.branch.referral.Branch
import io.branch.referral.BranchError
import io.branch.referral.util.BranchEvent
import io.branch.referral.util.LinkProperties
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry
import org.json.JSONObject



private fun errorGeneratedLink(generatedLinkStreamHandler: GeneratedLinkStreamHandler?,
                               registrar: PluginRegistry.Registrar, error: BranchError) {
    val intent = Intent()
    intent.putExtra("error", error.toString())
    generatedLinkStreamHandler!!.handleIntent(registrar.context(), intent)
}

private fun sendGeneratedLink(generatedLinkStreamHandler: GeneratedLinkStreamHandler?,
                              registrar: PluginRegistry.Registrar, link: String?) {
    val intent = Intent()
    if (link == null) return
    intent.putExtra("link", link)
    generatedLinkStreamHandler!!.handleIntent(registrar.context(), intent)
}

private fun generateLink(registrar: PluginRegistry.Registrar, generatedLinkStreamHandler: GeneratedLinkStreamHandler?,
                         buo: BranchUniversalObject, lp: LinkProperties) {
    buo.generateShortUrl(registrar.activeContext(), lp, {
        link, error -> if (error == null) sendGeneratedLink(generatedLinkStreamHandler, registrar, link)
    else errorGeneratedLink(generatedLinkStreamHandler, registrar, error)
    })
}

fun getBranchLatestParam(): String {
    val params = Branch.getInstance().latestReferringParams
    if (params != null)
        return params.toString()
    return ""
}



fun getBranchFirstParam(): String {
    val params = Branch.getInstance().firstReferringParams
    if (params != null)
        return params.toString()
    return ""
}

fun generateLinkHandler(registrar: PluginRegistry.Registrar, generatedLinkStreamHandler: GeneratedLinkStreamHandler?,
                        call: MethodCall) {
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
    generateLink(registrar, generatedLinkStreamHandler, buo, lp)
}

fun listOnGoogleSearch(registrar: PluginRegistry.Registrar, call: MethodCall) {
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
    buo.listOnGoogleSearch(registrar.activeContext(), lp)
}

fun trackContent(registrar: PluginRegistry.Registrar, call: MethodCall) {
    val buoJson = JSONObject(call.argument<String>("buoJson"))
    val buo = BranchUniversalObject.createInstance(buoJson)
    val eventType = call.argument<String>("eventType")
    BranchEvent(eventType).addContentItems(buo).logEvent(registrar.activeContext())
}

fun setUserID(call: MethodCall) {
    val userId = call.argument<String>("userId")
    Branch.getInstance().setIdentity(userId ?: "")
}

fun clearUserID() {
    Branch.getInstance().logout()
}

fun openUrl(activity: Activity, url: String, finishPreviousActivity: Boolean) {
    if(activity == null) {
        Log.e("BranchSDK", "Branch native Android SDK not initialized in openURL")
        return
    }

    val intent  = Intent(activity, activity.javaClass)
    intent.putExtra("branch", url)
    intent.putExtra("branch_force_new_session", true)

    if(finishPreviousActivity){
        activity.finish()
    }

    activity.startActivity(intent)
}