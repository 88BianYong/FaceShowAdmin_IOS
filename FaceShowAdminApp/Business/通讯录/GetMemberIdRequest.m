//
//  GetMemberIdRequest.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/9/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetMemberIdRequest.h"

@implementation GetMemberIdRequestItem_data

@end

@implementation GetMemberIdRequestItem

@end

@implementation GetMemberIdRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"login.getMemberId";
    }
    return self;
}
@end
