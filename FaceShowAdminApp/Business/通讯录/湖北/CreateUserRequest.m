//
//  CreateUserRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateUserRequest.h"

@implementation CreateUserRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [ConfigManager sharedInstance].server1_1;
        self.method = @"sysUser.create";
        self.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    }
    return self;
}
@end
