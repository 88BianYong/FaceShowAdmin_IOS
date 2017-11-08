//
//  UserSignInPercentRequest.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserSignInPercentRequest.h"

@implementation UserSignInPercentRequestItem_Data
@end

@implementation UserSignInPercentRequestItem
@end

@implementation UserSignInPercentRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.clazsUserSignInPercent";
        self.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    }
    return self;
}
@end
