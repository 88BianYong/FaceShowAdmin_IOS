//
//  LoginDataManager.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginDataManager.h"
#import "LoginRequest.h"
#import "GetUserInfoRequest.h"
#import "ClassListRequest.h"
#import "GetUserPlatformRequest.h"
#import "GetUserRolesRequest.h"

@interface LoginDataManager()
@property (nonatomic, strong) LoginRequest *loginRequest;
@property (nonatomic, strong) ClassListRequest *getClassRequest;
@property (nonatomic, strong) GetUserInfoRequest *getUserInfoRequest;
@property (nonatomic, strong) GetUserPlatformRequest *platformRequest;
@property (nonatomic, strong) GetUserRolesRequest *roleRequest;
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

+ (void)loginWithName:(NSString *)name password:(NSString *)password completeBlock:(void (^)(NSError *))completeBlock {
    LoginDataManager *manager = [LoginDataManager sharedInstance];
    [manager.loginRequest stopRequest];
    manager.loginRequest = [[LoginRequest alloc]init];
    manager.loginRequest.loginName = name;
    manager.loginRequest.password = [password md5];
    WEAK_SELF
    [manager.loginRequest startRequestWithRetClass:[LoginRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock, error);
            return;
        }
        LoginRequestItem *item = (LoginRequestItem *)retItem;
        UserModel *userModel = [[UserModel alloc] init];
        userModel.token = item.token;
        userModel.passport = item.passport;
        
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
            BLOCK_EXEC(completeBlock,platformItem,retItem,error);
        }];
    }];
}

@end
