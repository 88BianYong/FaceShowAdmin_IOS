//
//  UserManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserManager.h"

NSString * const kUserDidLoginNotification = @"kUserDidLoginNotification";
NSString * const kUserDidLogoutNotification = @"kUserDidLogoutNotification";

@implementation UserManager
@synthesize loginStatus = _loginStatus;

+ (UserManager *)sharedInstance {
    static dispatch_once_t once;
    static UserManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[UserManager alloc] init];
        sharedInstance.mainPage = MainPage_Undefined;
        [sharedInstance loadData];
    });
    
    return sharedInstance;
}

- (void)setLoginStatus:(BOOL)loginStatus {
    if (loginStatus) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kUserDidLoginNotification object:nil];
    }else {
        self.userModel = nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:kUserDidLogoutNotification object:nil];
    }
}

- (BOOL)loginStatus {
    if (self.userModel.token && self.userModel.imInfo.imToken) {
        return YES;
    }
    return NO;
}

- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    GetUserRolesRequestItem_data *data = self.userModel.roleRequestItem.data;
    if ([data roleExists:UserRole_PlatformAdmin] || [data roleExists:UserRole_PlatAdmin] || [data roleExists:UserRole_ProvinceAdmin] || [data roleExists:UserRole_ProjectAdmin] || [data roleExists:UserRole_ProjectSteward]) {
        self.mainPage = MainPage_TrainingProfile;
    }else {
        self.mainPage = MainPage_ClassDetail;
    };
//
//
//#ifdef HuBeiApp
//    if ([data roleExists:UserRole_PlatformAdmin]||
//        [data roleExists:UserRole_AreaAdmin]||
//        [data roleExists:UserRole_ProjectAdmin]||
//        [data roleExists:UserRole_ProjectSteward]||
//        [data roleExists:UserRole_ProvinceAdmin]) {
//        self.mainPage = MainPage_TrainingProfile;
//    }else if ([data roleExists:UserRole_Teacher]||[data roleExists:UserRole_UnknownTeacher]) {
//        self.mainPage = MainPage_ClassDetail;
//    }
//#else
//    if ([data roleExists:UserRole_PlatformAdmin]||[data roleExists:UserRole_AreaAdmin]||[data roleExists:UserRole_ProvinceAdmin]) {
//        self.mainPage = MainPage_TrainingProfile;
//    }else if ([data roleExists:UserRole_ProjectAdmin]||[data roleExists:UserRole_ProjectSteward]) {
//        self.mainPage = MainPage_MyProject;
//    }else if ([data roleExists:UserRole_Teacher]||[data roleExists:UserRole_UnknownTeacher]) {
//        self.mainPage = MainPage_ClassDetail;
//    }
//#endif
    [self saveData];
}

#pragma mark - 
- (void)saveData {
    NSString *json = [self.userModel toJSONString];
    [[NSUserDefaults standardUserDefaults]setValue:json forKey:@"user_model_key"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (!isEmpty(self.userModel)) {
        [[NSUserDefaults standardUserDefaults]setValue:self.userModel.mobilePhone forKey:@"last_login_user_mobile"];
    }
}

- (void)loadData {
    NSString *json = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_model_key"];
    if (json) {
        self.userModel = [[UserModel alloc]initWithString:json error:nil];
    }
}

@end
