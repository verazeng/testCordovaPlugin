#import <Cordova/CDV.h>

@interface CDVDemoPlugin : CDVPlugin {
  // Member variables go here.
}

- (void)alertView:(CDVInvokedUrlCommand*)command;
- (void)getDeviceInfo:(CDVInvokedUrlCommand *)command;
@end
