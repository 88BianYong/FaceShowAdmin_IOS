//
//  AddAppUseRecordRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AddAppUseRecordRequest.h"

@interface AddAppUseRecordRequest()
@property (nonatomic, strong) NSString *platId;
@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, strong) NSString *clazsId;
@property (nonatomic, strong) NSString *methord;
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
        ClassListRequestItem_clazsInfos *info =[UserManager sharedInstance].userModel.currentClass;
        self.platId = info?info.platId:@"0";
        self.projectId = info?info.projectId:@"0";
        self.clazsId = info?info.clazsId:@"0";
#ifdef HuBeiApp
        self.appName = @"FaceShowAdmin_Hubei";
#else
        self.appName = @"FaceShowAdmin";
#endif
        self.appVersion = [NSString stringWithFormat:@"v%@",[ConfigManager sharedInstance].clientVersion];
        self.osType = @"iOS";
        self.clientDeviceInfo = [NSString stringWithFormat:@"iOS %@",[UIDevice currentDevice].systemVersion];
        self.clientSysInfo = [ConfigManager sharedInstance].deviceModelName;
    }
    return self;
}

- (void)setActionType:(AppUseRecordActionType)actionType{
    if (_actionType != actionType) {
        _actionType = actionType;
    }
    [self setMethordByActionType:_actionType];
}

- (void)setMethordByActionType:(AppUseRecordActionType)actionType{
    NSString *stringType = [NSString stringWithFormat:@"%lu",(unsigned long)actionType];
    NSDictionary *releateDic = @{
                                 @"1":@"accountLogin",
                                 @"2":@"autoLogin",
                                 @"3":@"app.clazs.getStudentClazs"
                                 };
    self.methord = [NSString stringWithFormat:@"%@",releateDic[stringType]];
}

@end

