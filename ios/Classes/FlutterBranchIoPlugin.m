#import "FlutterBranchIoPlugin.h"
#import <flutter_branch_io_plugin/flutter_branch_io_plugin-Swift.h>

@implementation FlutterBranchIoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterBranchIoPlugin registerWithRegistrar:registrar];
}
@end
