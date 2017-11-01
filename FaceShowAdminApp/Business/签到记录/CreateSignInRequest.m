//
//  CreateSignInRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CreateSignInRequest.h"

@implementation CreateSignInRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.createSignIn";
        self.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    }
    return self;
}
@end
