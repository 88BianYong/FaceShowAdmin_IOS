//
//  GetCountClazsRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetCountClazsRequest.h"

@implementation GetCountClazsRequestItem_data
@end

@implementation GetCountClazsRequestItem
@end

@implementation GetCountClazsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.clazs.countClazs";
    }
    return self;
}
@end
