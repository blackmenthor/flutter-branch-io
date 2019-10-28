package com.anggach.flutterbranchioplugin.src

import android.content.Intent
import android.util.Log
import com.anggach.flutterbranchioplugin.DEBUG_NAME
import com.anggach.flutterbranchioplugin.INTENT_EXTRA_DATA
import io.branch.referral.Branch
import io.branch.referral.BranchError
import io.branch.referral.BranchUtil
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject


fun init(registrar: PluginRegistry.Registrar) {
    if (!BranchUtil.isTestModeEnabled()) {
        Branch.getInstance(registrar.activity().applicationContext)
    } else {
        Branch.getTestInstance(registrar.activity().applicationContext)
    }

    // Branch logging for debugging
    Branch.enableDebugMode()

    // Branch object initialization
    Branch.getAutoInstance(registrar.activity().applicationContext)
}

fun setUpBranchIo(registrar: PluginRegistry.Registrar, deepLinkStreamHandler: DeepLinkStreamHandler?, result: Result) {
    init(registrar)
    Branch.getInstance().initSession({ referringParams: JSONObject?, error: BranchError? ->
        Log.d(DEBUG_NAME, "BRANCH CALLBACK")
        if (error == null) {
            result.success("BRANCH IO INITIALIZED")
            val params = referringParams?.toString()
            val intent = Intent()
            intent.putExtra(INTENT_EXTRA_DATA, params)
            deepLinkStreamHandler!!.handleIntent(registrar.activity(), intent)
        } else {
            result.error("1", "BRANCH IO INITIALIZATION ERROR ${error.message}", null)
        }
    }, registrar.activity().intent.data, registrar.activity())

}