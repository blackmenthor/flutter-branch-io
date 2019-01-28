# flutter-branch-io
Flutter plugin implemented Branch IO's SDK to Flutter.

Currently only supported Android, still need to work on iOS's swift side.

Implemented function:
- Initialization and get Deep Link data to a subscribe-able stream on dart.
- Create BUO and MetaData model
- Generate new deeplink and get the link
- List BUO on google search
- Track content & evnt
- Track user by id

# HOW TO USE
- Import flutter_branch_io_plugin to your `pubspec.yaml`
- Change these setups in your `AndroidManifest.xml`

    - Change your application class to `android:name="com.anggach.flutterbranchioplugin.src.FlutterBranchIOApp"`
    - Open your MainActivity and change the class to extend FlutterBranchIOActivity
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
        FlutterBranchIoPlugin.setupBranchIO();
        FlutterBranchIoPlugin.listenToDeepLinkStream().listen((string) {
          print("DEEPLINK $string");
          setState(() {
            this._data = string;
          });
        });
        FlutterBranchIoPlugin.listenToOnStartStream().listen((string) {
          print("ONSTART");
          FlutterBranchIoPlugin.setupBranchIO();
        });
    ```

# Contributor
- Angga Dwi Arifandi (angga.dwi@oval.id)
- Abdul Ghapur (gofur@oval.id)