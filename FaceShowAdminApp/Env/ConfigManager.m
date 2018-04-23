//
//  ConfigManager.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ConfigManager.h"
#import <FCUUID.h>
#import <UIDevice+HardwareName.h>

BOOL mockFrameworkOn = NO;
BOOL testFrameworkOn = NO;

#ifdef DEBUG
NSString * const kServer = @"http://orz.yanxiu.com/pxt/platform/data.api";
NSString * const kLoginServer = @"http://orz.yanxiu.com/uc/appLogin";
NSString * const kEasygoServer = @"http://orz.yanxiu.com/easygo/multiUpload";
#else
NSString * const kServer = @"http://yxb.yanxiu.com/pxt/platform/data.api";
NSString * const kLoginServer = @"http://pp.yanxiu.com/uc/appLogin";
NSString * const kEasygoServer = @"http://b.yanxiu.com/easygo/multiUpload";
#endif

@implementation ConfigManager
+ (ConfigManager *)sharedInstance {
    static dispatch_once_t once;
    static ConfigManager *sharedInstance;
    dispatch_once(&once, ^{
       sharedInstance = [[ConfigManager alloc]init];
    });
    
    return sharedInstance;
}

#pragma mark - properties
- (NSString *)server {
    return kServer;
}

- (NSString *)loginServer {
    return kLoginServer;
}

- (NSString *)easygo {
    return kEasygoServer;
}

- (NSString *)appName {
    if (!_appName) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _appName = [infoDictionary objectForKey:@"CFBundleName"];
    }
    return _appName;
}

- (NSString *)clientVersion {
    if (!_clientVersion) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _clientVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return _clientVersion;
}

- (NSString *)deviceID {
    return [FCUUID uuidForDevice];
}

- (NSString *)deviceType {
    if (!_deviceType) {
        _deviceType = [[UIDevice currentDevice] platform];
    }
    return _deviceType;
}

- (NSString *)osType {
    return @"ios";
}

- (NSString *)osVersion {
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)deviceName {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"iPad";
    } else {
        return @"iPhone";
    }
}

@end
