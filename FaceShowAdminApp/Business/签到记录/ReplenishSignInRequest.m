//
//  ReplenishSignInRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ReplenishSignInRequest.h"

@implementation ReplenishSignInRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.replenishSignIn";
    }
    return self;
}
@end
