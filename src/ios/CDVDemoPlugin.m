#import "CDVDemoPlugin.h"

@interface CDVDemoPlugin () <UIAlertViewDelegate>
@property (nonatomic)CDVInvokedUrlCommand *command;
@end

@implementation CDVDemoPlugin
- (void)alertView:(CDVInvokedUrlCommand*)command
{
    _command = command;
    NSDictionary *args = [command.arguments objectAtIndex:0];
    
    UIAlertView *view = [[UIAlertView alloc]
                         initWithTitle:[args objectForKey:@"title"]
                         message:[args objectForKey:@"message"]
                         delegate:self
                         cancelButtonTitle:[args objectForKey:@"cancelText"]
                         otherButtonTitles:nil, nil];
    [view show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        CDVPluginResult *pluginResult =
        [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"call back successfully!"];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:_command.callbackId];
    }
}

- (void)getDeviceInfo:(CDVInvokedUrlCommand *)command {
    NSDictionary *info = [self deviceProperties];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (NSDictionary*)deviceProperties
{
    UIDevice* device = [UIDevice currentDevice];
    NSMutableDictionary* devProps = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [devProps setObject:@"Apple" forKey:@"manufacturer"];
    [devProps setObject:[device model] forKey:@"model"];
    [devProps setObject:@"iOS" forKey:@"platform"];
    [devProps setObject:[device systemVersion] forKey:@"version"];
    [devProps setObject:[self uniqueAppInstanceIdentifier:device] forKey:@"uuid"];
    [devProps setObject:[[self class] cordovaVersion] forKey:@"cordova"];
    
    NSDictionary* devReturn = [NSDictionary dictionaryWithDictionary:devProps];
    return devReturn;
}

+ (NSString*)cordovaVersion
{
    return CDV_VERSION;
}

- (NSString*)uniqueAppInstanceIdentifier:(UIDevice*)device
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    static NSString* UUID_KEY = @"CDVUUID";
    
    NSString* app_uuid = [userDefaults stringForKey:UUID_KEY];
    
    if (app_uuid == nil) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        
        app_uuid = [NSString stringWithString:(__bridge NSString*)uuidString];
        [userDefaults setObject:app_uuid forKey:UUID_KEY];
        [userDefaults synchronize];
        
        CFRelease(uuidString);
        CFRelease(uuidRef);
    }
    
    return app_uuid;
}

@end

