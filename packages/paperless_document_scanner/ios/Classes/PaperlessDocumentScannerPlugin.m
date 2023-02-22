#import "SimpleEdgeDetectionPlugin.h"
#if __has_include(<paperless_document_scanner/paperless_document_scanner-Swift.h>)
#import <paperless_document_scanner/paperless_document_scanner-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "paperless_document_scanner-Swift.h"
#endif

@implementation SimpleEdgeDetectionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSimpleEdgeDetectionPlugin registerWithRegistrar:registrar];
}
@end
