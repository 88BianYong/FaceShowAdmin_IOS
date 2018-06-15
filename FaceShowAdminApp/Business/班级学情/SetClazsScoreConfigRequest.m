//
//  SetClazsScoreConfigRequest.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SetClazsScoreConfigRequest.h"

@implementation SetClazsScoreConfigRequestItem_data
@end

@implementation SetClazsScoreConfigRequestItem
@end

@implementation SetClazsScoreConfigRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"clazs.setClazsScoreConfig";
    }
    return self;
}
@end
