//
//  SignInDetailRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInDetailRequest.h"

@implementation SignInDetailRequestItem_data
@end

@implementation SignInDetailRequestItem
@end

@implementation SignInDetailRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.manage.interact.getSignIn";
    }
    return self;
}
@end
