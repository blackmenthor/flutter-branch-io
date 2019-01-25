package com.anggach.flutterbranchiopluginexample

import android.os.Bundle
import com.anggach.flutterbranchioplugin.src.FlutterBranchIOActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterBranchIOActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  }
}
