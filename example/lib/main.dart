import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_android_lifecycle/flutter_android_lifecycle.dart';
import 'package:flutter_branch_io_plugin/flutter_branch_io_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _data = '-';
  String generatedLink = '-';
  String error = '-';

  @override
  void initState() {
    super.initState();

    try {
      setUpBranch();
    } catch (error) {
      setState(() {
        this.error = error.toString();
      });
      print("BRANCH ERROR ${error.toString()}");
    }
  }

  void setUpBranch() {
    if (Platform.isAndroid) {
      FlutterBranchIoPlugin.setupBranchIO();
    }

    FlutterBranchIoPlugin.listenToDeepLinkStream().listen((string) {
      print("DEEPLINK $string");
      setState(() {
        this._data = string;
      });
    });
    if (Platform.isAndroid) {
      FlutterAndroidLifecycle.listenToOnStartStream().listen((string) {
        print("ONSTART");
        FlutterBranchIoPlugin.setupBranchIO();
      });
    }

    FlutterBranchIoPlugin.listenToGeneratedLinkStream().listen((link) {
      print("GET LINK IN FLUTTER");
      print(link);
      setState(() {
        this.generatedLink = link;
      });
    });

    FlutterBranchIoPlugin.generateLink(
        FlutterBranchUniversalObject()
            .setCanonicalIdentifier("content/12345")
            .setTitle("My Content Title")
            .setContentDescription("My Content Description")
            .setContentImageUrl("https://lorempixel.com/400/400")
            .setContentIndexingMode(BUO_CONTENT_INDEX_MODE.PUBLIC)
            .setLocalIndexMode(BUO_CONTENT_INDEX_MODE.PUBLIC),
        lpChannel: "facebook",
        lpFeature: "sharing",
        lpCampaign: "content 123 launch",
        lpStage: "new user",
        lpControlParams: {
          "url": "http://www.google.com"
        }
    );

    FlutterBranchIoPlugin.trackContent( FlutterBranchUniversalObject()
        .setCanonicalIdentifier("content/12345")
        .setTitle("My Content Title")
        .setContentDescription("My Content Description")
        .setContentImageUrl("https://lorempixel.com/400/400")
        .setContentIndexingMode(BUO_CONTENT_INDEX_MODE.PUBLIC)
        .setLocalIndexMode(BUO_CONTENT_INDEX_MODE.PUBLIC), FlutterBranchStandardEvent.VIEW_ITEM);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                      "LATEST DATA BRANCH $_data"
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                      "GENERATED LINK $generatedLink"
                  ),
                ),
                error.isEmpty ? Container() : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                      "ERROR: $error"
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
