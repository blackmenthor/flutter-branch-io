package com.anggach.flutterbranchioplugin.src

import io.branch.referral.Branch
import io.branch.referral.BranchUtil
import io.flutter.app.FlutterApplication

class FlutterBranchIOApp : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()

        if (!BranchUtil.isTestModeEnabled()) {
            Branch.getInstance(this)
        } else {
            Branch.getTestInstance(this)
        }

        // Branch logging for debugging
        Branch.enableDebugMode()

        // Branch object initialization
        Branch.getAutoInstance(this)
    }

}