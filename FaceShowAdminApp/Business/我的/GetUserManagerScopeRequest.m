//
//  GetUserManagerScopeRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetUserManagerScopeRequest.h"

@implementation GetUserManagerScopeRequestItem_data
@end

@implementation GetUserManagerScopeRequestItem
@end

@implementation GetUserManagerScopeRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.platform.getUserManagerScope";
    }
    return self;
}
@end
