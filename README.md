# flutter-branch-io

Flutter plugin implemented Branch IO's SDK to Flutter.

Supports both Android and iOS.

Implemented function:

- Initialization and get Deep Link data to a subscribe-able stream on dart.
- Create BUO and MetaData model
- Generate new deeplink and get the link
- List BUO on google search
- Track content & evnt
- Track user by id

## Setup

### Setup iOS Applink

- [Configure associated domains via Xcode](https://docs.branch.io/apps/ios/#configure-associated-domains)

### Setup Android Applink

- Change these setups in your `AndroidManifest.xml`
  - Add these inside your AndroidManifest.xml (inside activity tag, after the Main and Launcher intent-filter)

    ```xml
        <!-- Branch URI scheme -->
        <intent-filter>
            <data android:scheme="<your custom scheme>" android:host="open"/>
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />
        </intent-filter>
    ```

    ```xml
        <!-- Branch App Links -->
        <intent-filter android:autoVerify="true">
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />
            <data android:scheme="https" android:host="<your branch app host>.test-app.link" /><!-- Test Scheme -->
            <data android:scheme="https" android:host="<your branch app host>-alternate.test-app.link" /> <!-- Test Scheme -->
            <data android:scheme="https" android:host="<your branch app host>.app.link" /> <!-- Live Scheme -->
            <data android:scheme="https" android:host="<your branch app host>-alternate.app.link" /> <!-- Live Scheme -->
        </intent-filter>
    ```

    ```xml
        <!-- Branch install referrer tracking -->
        <receiver android:name="io.branch.referral.InstallListener" android:exported="true">
            <intent-filter>
                <action android:name="com.android.vending.INSTALL_REFERRER" />
            </intent-filter>
        </receiver>
    ```

### Setup Flutter

- Import flutter_branch_io_plugin to your `pubspec.yaml`
- You need to call this code inside your application's initState. You may pass test or live branch key as needed.

    ```dart
        FlutterBranchIoPlugin.initBranchIO('<your branch key here>');
        FlutterBranchIoPlugin.listenToDeepLinkStream().listen((string) {
          // PROCESS DEEPLINK HERE
        });
    ```

## Functions

- To generate new deep link from flutter, you can use this (Support both Android & iOS)

First, you need to subscribe to the generated link stream, which will produce the generated link after you created a link from a branch universal object

```dart

    FlutterBranchIoPlugin.listenToGeneratedLinkStream().listen((link) {
          print("GET LINK IN FLUTTER");
          print(link);
          setState(() {
            this.generatedLink = link;
          });
        });
```

Then, you can start generate new links based on any Branch Universal Object you pass, and you can also add some Link Properties inside (support Android & iOS)

```dart

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
```

- Track Content (Support Both Android & iOS)

To track content, you can create a new branch universal object and some event identifier (String)

```dart
    FlutterBranchIoPlugin.trackContent( FlutterBranchUniversalObject()
            .setCanonicalIdentifier("content/12345")
            .setTitle("My Content Title")
            .setContentDescription("My Content Description")
            .setContentImageUrl("https://lorempixel.com/400/400")
            .setContentIndexingMode(BUO_CONTENT_INDEX_MODE.PUBLIC)
            .setLocalIndexMode(BUO_CONTENT_INDEX_MODE.PUBLIC), FlutterBranchStandardEvent.VIEW_ITEM);
```

- Set User ID (support both Android & iOS)

To set user id for current session, you can use

```dart
    FlutterBranchIoPlugin.setUserIdentity(USER_ID)
```

- Clear User ID (support both Android & iOS)

To clear user id for current session, you can use

```dart
    FlutterBranchIoPlugin.clearUserIdentity()
```

- List Universal Object on Google Search (support Android only)

To list an universal object on google search, you can use

```dart
    FlutterBranchIoPlugin.listOnGoogleSearch(
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
```

## Version

- 0.0.1
  - Initial upload
- 0.0.1+2
  - Add Swift dependencies and version
- 0.0.1+3
  - Fix Branch data not received after user install
- 0.0.1+4
  - Fix method not implemented errors on iOS
- 0.0.1+5
  - Implement iOS swift side
- 0.0.2
  - add iml to gitignore & adjust to Branch's new SDK functions including:
    - remove arguments from isTestModeEnabled
    - change enableLogging to enableDebugMode because deprecated
- 0.0.2+1
  - Change README's obsolete instructions for Android
- 0.0.2+2
  - Upgrade Kotlin version to 1.3.21

## Contributor

- Angga Dwi Arifandi (angga.dwi@oval.id)
- Abdul Ghapur (gofur@oval.id)
