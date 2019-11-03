

import Flutter
import UIKit

class EventStreamHandler: NSObject, FlutterStreamHandler {
    public var eventSink: FlutterEventSink? = nil
    
    // EventChannel.StreamHandler methods
    public func onListen(withArguments _: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    public func onCancel(withArguments _: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
