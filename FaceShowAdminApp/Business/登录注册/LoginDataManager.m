//
//  LoginDataManager.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginDataManager.h"
#import "LoginRequest.h"
//#import "GetCurrentClazsRequest.h"
//#import "GetUserInfoRequest.h"

@interface LoginDataManager()
@property (nonatomic, strong) LoginRequest *loginRequest;
//@property (nonatomic, strong) GetCurrentClazsRequest *getClassRequest;
//@property (nonatomic, strong) GetUserInfoRequest *getUserInfoRequest;
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
//        [UserManager sharedInstance].userModel = userModel;
//        
//        [manager.getClassRequest stopRequest];
//        manager.getClassRequest = [[GetCurrentClazsRequest alloc] init];
//        [manager.getClassRequest startRequestWithRetClass:[GetCurrentClazsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
//            if (error) {
//                BLOCK_EXEC(completeBlock, error);
//                return;
//            }
//            
//            [manager.getUserInfoRequest stopRequest];
//            manager.getUserInfoRequest = [[GetUserInfoRequest alloc] init];
//            [manager.getUserInfoRequest startRequestWithRetClass:[GetUserInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
//                if (error) {
//                    BLOCK_EXEC(completeBlock, error);
//                    return;
//                }
//                GetUserInfoRequestItem *userInfo = (GetUserInfoRequestItem *)retItem;
//                [[UserManager sharedInstance].userModel updateFromUserInfo:userInfo.data];
//                BLOCK_EXEC(completeBlock, nil);
//            }];
//        }];
//    }];
}

@end
