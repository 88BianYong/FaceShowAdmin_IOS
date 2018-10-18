//
//  UpdateSignInRequest.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "UpdateSignInRequest.h"

@implementation UpdateSignInRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.updateSignIn";
    }
    return self;
}

@end
