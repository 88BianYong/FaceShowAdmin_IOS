//
//  GetClazsScoreConfigRequest.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetClazsScoreConfigRequest.h"

@implementation GetClazsScoreConfigRequestItem_configItem
@end

@implementation GetClazsScoreConfigRequestItem_data
@end

@implementation GetClazsScoreConfigRequestItem
@end

@implementation GetClazsScoreConfigRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"clazs.getClazsScoreConfig";
    }
    return self;
}
@end
