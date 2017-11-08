//
//  CreateMemberRequest.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CreateMemberRequest.h"

@implementation CreateMemberRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"sysUser.create";
        self.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    }
    return self;
}
@end
