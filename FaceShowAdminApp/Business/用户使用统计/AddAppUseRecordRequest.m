//
//  AddAppUseRecordRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AddAppUseRecordRequest.h"

@interface AddAppUseRecordRequest()
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *clientSysInfo;
@property (nonatomic, strong) NSString *clientDeviceInfo;
@property (nonatomic, strong) NSString *osType;
@end

@implementation AddAppUseRecordRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"operate.addRecord";
#ifdef HuBeiApp
        self.appName = @"FaceShowAdmin_Hubei";
#else
        self.appName = @"FaceShowAdmin";
#endif
        self.appVersion = [ConfigManager sharedInstance].clientVersion;
        self.osType = @"iOS";
        self.clientDeviceInfo = [UIDevice currentDevice].systemVersion;
        self.clientSysInfo = [ConfigManager sharedInstance].deviceModelName;
    }
    return self;
}
@end

