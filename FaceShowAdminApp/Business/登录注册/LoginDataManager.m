//
//  LoginDataManager.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginDataManager.h"
#import "LoginRequest.h"
#import "AppCodeLoginRequest.h"
#import "GetUserInfoRequest.h"
#import "ClassListRequest.h"
#import "GetUserPlatformRequest.h"
#import "GetUserRolesRequest.h"
#import "AppUseRecordManager.h"

@interface LoginDataManager()
//@property (nonatomic, strong) LoginRequest *loginRequest;
@property (nonatomic, strong) YXGetRequest *loginBaseRequest;
@property (nonatomic, strong) ClassListRequest *getClassRequest;
@property (nonatomic, strong) GetUserInfoRequest *getUserInfoRequest;
@property (nonatomic, strong) GetUserPlatformRequest *platformRequest;
@property (nonatomic, strong) GetUserRolesRequest *roleRequest;
@property (nonatomic, copy) void(^loginBlock)(NSError *error);
@end

@implementation LoginDataManager

+ (LoginDataManager *)sharedInstance {
    static LoginDataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LoginDataManager new];
    });
    return manager;
}

+ (YXGetRequest *)getRequestWithName:(NSString *)name password:(NSString *)password LoginType:(AppLoginType)type{
    switch (type) {
        case AppLoginType_AccountLogin:
        {
            LoginRequest *loginRequest = [[LoginRequest alloc]init];
            loginRequest.loginName = name;
            loginRequest.password = [password md5];
            return loginRequest;
        }
        case AppLoginType_AppCodeLogin:
        {
            AppCodeLoginRequest *appCodeLoginRequest = [[AppCodeLoginRequest alloc] init];
            appCodeLoginRequest.mobile = name;
            appCodeLoginRequest.code = password;
            return appCodeLoginRequest;
        }
        default:
            return nil;
    }
}


+ (void)loginWithName:(NSString *)name password:(NSString *)password loginType:(AppLoginType)type completeBlock:(void(^)(NSError *error))completeBlock{
    LoginDataManager *manager = [LoginDataManager sharedInstance];
    [manager.loginBaseRequest stopRequest];
    manager.loginBaseRequest = [self getRequestWithName:name password:password LoginType:type];
    WEAK_SELF
    [manager.loginBaseRequest startRequestWithRetClass:[LoginRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock, error);
            return;
        }
        LoginRequestItem *item = (LoginRequestItem *)retItem;
        UserModel *userModel = [[UserModel alloc] init];
        userModel.token = item.token;
        userModel.passport = item.passport;
        manager.loginBlock = completeBlock;

//        [manager fetchClazsRequestWithUserModel:userModel];
//    }];
//
//}
//
//+ (void)loginWithName:(NSString *)name password:(NSString *)password completeBlock:(void (^)(NSError *))completeBlock {
//    LoginDataManager *manager = [LoginDataManager sharedInstance];
//    [manager.loginRequest stopRequest];
//    manager.loginRequest = [[LoginRequest alloc]init];
//    manager.loginRequest.loginName = name;
//    manager.loginRequest.password = [password md5];
//    WEAK_SELF
//    [manager.loginRequest startRequestWithRetClass:[LoginRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
//        STRONG_SELF
//        if (error) {
//            BLOCK_EXEC(completeBlock, error);
//            return;
//        }
//        LoginRequestItem *item = (LoginRequestItem *)retItem;
//        UserModel *userModel = [[UserModel alloc] init];
//        userModel.token = item.token;
//        userModel.passport = item.passport;

        [self requestPlatformAndRoleWithToken:item.token completeBlock:^(GetUserPlatformRequestItem *platform, GetUserRolesRequestItem *roles, NSError *error) {
            if (error) {
                BLOCK_EXEC(completeBlock, error);
                return;
            }
            userModel.platformRequestItem = platform;
            userModel.roleRequestItem = roles;
            if ([roles.data roleExists:UserRole_Teacher]||[roles.data roleExists:UserRole_UnknownTeacher]) {
                [manager.getClassRequest stopRequest];
                manager.getClassRequest = [[ClassListRequest alloc] init];
                manager.getClassRequest.token = userModel.token;
                GetUserPlatformRequestItem_platformInfos *plat = platform.data.platformInfos.firstObject;
                manager.getClassRequest.platId = plat.platformId;
                [manager.getClassRequest startRequestWithRetClass:[ClassListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
                    if (error) {
                        BLOCK_EXEC(completeBlock, error);
                        return;
                    }
                    ClassListRequestItem *item = (ClassListRequestItem *)retItem;
                    userModel.clazsInfos = item.data.clazsInfos;
                    
                    [manager.getUserInfoRequest stopRequest];
                    manager.getUserInfoRequest = [[GetUserInfoRequest alloc] init];
                    manager.getUserInfoRequest.token = userModel.token;
                    [manager.getUserInfoRequest startRequestWithRetClass:[GetUserInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
                        if (error) {
                            BLOCK_EXEC(completeBlock, error);
                            return;
                        }
                        GetUserInfoRequestItem *userInfo = (GetUserInfoRequestItem *)retItem;
                        [userModel updateFromUserInfo:userInfo.data];
                        [UserManager sharedInstance].userModel = userModel;
                        if (userModel.clazsInfos.count == 1) {
                            userModel.currentClass = userModel.clazsInfos.firstObject;
                            [[UserManager sharedInstance] saveData];
                        }
                        //使用情况统计
                        AddAppUseRecordRequest *request = [[AddAppUseRecordRequest alloc]init];
                        request.actionType = AppUseRecordActionType_AccountLogin;
                        [[AppUseRecordManager sharedInstance]addRecord:request];
                        [UserManager sharedInstance].loginStatus = YES;
                    }];
                }];
            }else {
                [manager.getUserInfoRequest stopRequest];
                manager.getUserInfoRequest = [[GetUserInfoRequest alloc] init];
                manager.getUserInfoRequest.token = userModel.token;
                [manager.getUserInfoRequest startRequestWithRetClass:[GetUserInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
                    if (error) {
                        BLOCK_EXEC(completeBlock, error);
                        return;
                    }
                    GetUserInfoRequestItem *userInfo = (GetUserInfoRequestItem *)retItem;
                    [userModel updateFromUserInfo:userInfo.data];
                    [UserManager sharedInstance].userModel = userModel;
                    if (userModel.clazsInfos.count == 1) {
                        userModel.currentClass = userModel.clazsInfos.firstObject;
                        [[UserManager sharedInstance] saveData];
                    }
                    //使用情况统计
                    AddAppUseRecordRequest *request = [[AddAppUseRecordRequest alloc]init];
                    request.actionType = AppUseRecordActionType_AccountLogin;
                    [[AppUseRecordManager sharedInstance]addRecord:request];
                    [UserManager sharedInstance].loginStatus = YES;
                }];
            }
        }];
    }];
}

+ (void)requestPlatformAndRoleWithToken:(NSString *)token completeBlock:(void (^)(GetUserPlatformRequestItem *platform, GetUserRolesRequestItem *roles, NSError *error))completeBlock {
    LoginDataManager *manager = [LoginDataManager sharedInstance];
    [manager.platformRequest stopRequest];
    manager.platformRequest = [[GetUserPlatformRequest alloc]init];
    manager.platformRequest.token = token;
    WEAK_SELF
    [manager.platformRequest startRequestWithRetClass:([GetUserPlatformRequestItem class]) andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,nil,error);
            return;
        }
        GetUserPlatformRequestItem *platformItem = (GetUserPlatformRequestItem *)retItem;
        [manager.roleRequest stopRequest];
        manager.roleRequest = [[GetUserRolesRequest alloc]init];
        GetUserPlatformRequestItem_platformInfos *platform = platformItem.data.platformInfos.firstObject;
        manager.roleRequest.platId = platform.platformId;
        manager.roleRequest.token = token;
        WEAK_SELF
        [manager.roleRequest startRequestWithRetClass:[GetUserRolesRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            if (error) {
                BLOCK_EXEC(completeBlock,nil,nil,error);
                return;
            }
            GetUserRolesRequestItem *item = retItem;
            if ([item.data isUnknownRole]) {
                NSError *unknownRoleErr = [NSError errorWithDomain:@"unkown_role" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"当前账号权限不足"}];
                BLOCK_EXEC(completeBlock,nil,nil,unknownRoleErr);
                return;
            }
            BLOCK_EXEC(completeBlock,platformItem,retItem,error);
        }];
    }];
}

@end
