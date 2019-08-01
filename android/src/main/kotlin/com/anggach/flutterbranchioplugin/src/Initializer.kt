package com.anggach.flutterbranchioplugin.src

import android.content.Intent
import android.util.Log
import com.anggach.flutterbranchioplugin.DEBUG_NAME
import com.anggach.flutterbranchioplugin.INTENT_EXTRA_DATA
import io.branch.referral.Branch
import io.branch.referral.BranchError
import io.branch.referral.BranchUtil
import io.flutter.plugin.common.PluginRegistry
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

fun initBranchIO(registrar: PluginRegistry.Registrar, deepLinkStreamHandler: DeepLinkStreamHandler?) {
    init(registrar)
    Branch.getInstance().initSession({ referringParams: JSONObject?, error: BranchError? ->
        Log.d(DEBUG_NAME, "BRANCH CALLBACK")
        if (error == null) {
            val params = referringParams?.toString()
            val intent = Intent(registrar.activity(), registrar.activity().javaClass)
            intent.putExtra(INTENT_EXTRA_DATA, params)
            deepLinkStreamHandler!!.handleIntent(registrar.activity(), intent)
        } else {
            Log.i(DEBUG_NAME, error.message)
        }
    }, registrar.activity().intent.data, registrar.activity())

}