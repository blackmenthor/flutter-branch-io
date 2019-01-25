package com.anggach.flutterbranchioplugin.src

import android.content.Context
import io.branch.indexing.BranchUniversalObject
import io.branch.referral.Branch
import io.branch.referral.util.BRANCH_STANDARD_EVENT
import io.branch.referral.util.BranchEvent

// CONTENT TRACKING

fun trackSearchEvent(buo: BranchUniversalObject, context: Context) {
    BranchEvent(BRANCH_STANDARD_EVENT.SEARCH).addContentItems(buo).logEvent(context)
}

fun trackTutorialEvent(buo: BranchUniversalObject, context: Context) {
    BranchEvent(BRANCH_STANDARD_EVENT.COMPLETE_TUTORIAL).addContentItems(buo).logEvent(context)
}

fun trackCompleteRegistrationEvent(buo: BranchUniversalObject, context: Context) {
    BranchEvent(BRANCH_STANDARD_EVENT.COMPLETE_REGISTRATION).addContentItems(buo).logEvent(context)
}

fun trackShareEvent(buo: BranchUniversalObject, context: Context) {
    BranchEvent(BRANCH_STANDARD_EVENT.SHARE).addContentItems(buo).logEvent(context)
}

fun trackPurchaseEvent(buo: BranchUniversalObject, context: Context) {
    BranchEvent(BRANCH_STANDARD_EVENT.PURCHASE).addContentItems(buo).logEvent(context)
}

fun trackViewEvent(buo: BranchUniversalObject, context: Context) {
    BranchEvent(BRANCH_STANDARD_EVENT.VIEW_ITEM).addContentItems(buo).logEvent(context)
}

fun listOnGoogleSearch(buo: BranchUniversalObject, context: Context) {
    buo.listOnGoogleSearch(context)
}

// USER TRACKING

fun setUserIdentity(identity: String) {
    Branch.getInstance().setIdentity(identity)
}

fun logoutUser() {
    Branch.getInstance().logout()
}

fun enableUserTracking() {
    Branch.getInstance().disableTracking(false)
}

fun disableUserTracking() {
    Branch.getInstance().disableTracking(true)
}