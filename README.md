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

## HOW TO USE on iOS
- You need to call this code inside your application's initState
    ```
        if (Platform.isAndroid) FlutterBranchIoPlugin.setupBranchIO(); // will throw an exception if it fails
        FlutterBranchIoPlugin.listenToDeepLinkStream().listen((string) {
          print("DEEPLINK $string");
          // PROCESS DEEPLINK HERE
        });
        if (Platform.isAndroid) {
          FlutterAndroidLifecycle.listenToOnStartStream().listen((string) {
            print("ONSTART");
            FlutterBranchIoPlugin.setupBranchIO();
          });
        }
    ```
# HOW TO USE on Android
- Import flutter_branch_io_plugin to your `pubspec.yaml`
- Change these setups in your `AndroidManifest.xml`

    - Open your MainActivity and import `com.anggach.flutterandroidlifecycle.FlutterAndroidLifecycleActivity`
    - Change the MainActivity class to extend FlutterAndroidLifecycleActivity
    - Add this inside your AndroidManifest.xml (inside activity tag, after the Main and Launcher intent-filter)

        ```
            <!-- Branch URI scheme -->
            <intent-filter>
                <data android:scheme="YOURSCHEME" android:host="open"/>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
            </intent-filter>
        ```
        
        ```
            <!-- Branch App Links -->
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="https" android:host="YOURHOST.test-app.link" />
            </intent-filter>
        ```

    Where YOURSCHEME is the Deep Link Scheme you setup at Branch.io dashboard,
     and YOURHOST is the Deep Link Host you setup at the dashboard
    - And add this inside application, (right after </activity>)
        ```
            <!-- Branch init -->
            <meta-data android:name="io.branch.sdk.BranchKey" android:value="YOURLIVEKEY" />
            <meta-data android:name="io.branch.sdk.BranchKey.test" android:value="YOURTESTKEY" />
            <meta-data android:name="io.branch.sdk.TestMode" android:value="true" /> <!-- Set to true to use Branch_Test_Key -->
        ```

        ```
            <!-- Branch install referrer tracking -->
            <receiver android:name="io.branch.referral.InstallListener" android:exported="true">
                <intent-filter>
                    <action android:name="com.android.vending.INSTALL_REFERRER" />
                </intent-filter>
            </receiver>
        ```
    Where YOURLIVEKEY is your Branch.io live key, and YOURTESTKEY is your Branch.io test key.

    - Last, you need to call this code inside your application's initState
    ```
        if (Platform.isAndroid) FlutterBranchIoPlugin.setupBranchIO();  // will throw an exception if it fails
        FlutterBranchIoPlugin.listenToDeepLinkStream().listen((string) {
          print("DEEPLINK $string");
          // PROCESS DEEPLINK HERE
        });
        if (Platform.isAndroid) {
          FlutterAndroidLifecycle.listenToOnStartStream().listen((string) {
            print("ONSTART");
            FlutterBranchIoPlugin.setupBranchIO();
          });
        }
    ```

# Functions
- To generate new deep link from flutter, you can use this (Support both Android & iOS)
First, you need to subscribe to the generated link stream, which will produce the generated link after you created a link from a branch universal object
```

    FlutterBranchIoPlugin.listenToGeneratedLinkStream().listen((link) {
          print("GET LINK IN FLUTTER");
          print(link);
          setState(() {
            this.generatedLink = link;
          });
        });
```

Then, you can start generate new links based on any Branch Universal Object you pass, and you can also add some Link Properties inside (support Android & iOS)
```

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
to track content, you can create a new branch universal object and some event identifier (String)
```
    FlutterBranchIoPlugin.trackContent( FlutterBranchUniversalObject()
            .setCanonicalIdentifier("content/12345")
            .setTitle("My Content Title")
            .setContentDescription("My Content Description")
            .setContentImageUrl("https://lorempixel.com/400/400")
            .setContentIndexingMode(BUO_CONTENT_INDEX_MODE.PUBLIC)
            .setLocalIndexMode(BUO_CONTENT_INDEX_MODE.PUBLIC), FlutterBranchStandardEvent.VIEW_ITEM);
```

- Set User ID (support both Android & iOS)
to set user id for current session, you can use
```
    FlutterBranchIoPlugin.setUserIdentity(USER_ID)
```

- Clear User ID (support both Android & iOS)
to clear user id for current session, you can use
```
    FlutterBranchIoPlugin.clearUserIdentity()
```

- List Universal Object on Google Search (support Android only)
to list an universal object on google search, you can use
```
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

# Version
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
    remove arguments from isTestModeEnabled
    change enableLogging to enableDebugMode because deprecated
- 0.0.2+1
    - Change README's obsolete instructions for Android
- 0.0.2+2
    - Upgrade Kotlin version to 1.3.21
- 0.0.3
    - Notify on Android if branch io can't be initialized
- 1.0.0
    - Implement iOS scheme so we don't need to edit the `AppDelegate` file directly
- 1.0.1
    - Fix errors in v1.0.0
    - Update `flutter_android_lifecycle` to v1.0.0

# Contributor
- Angga Dwi Arifandi (anggadwiarifandi96@gmail.com)
- Abdul Ghapur (gofur@oval.id)
- Amond (amond@amond.net)
