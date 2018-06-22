//
//  GetUserHomeworkDetailRequest.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetUserHomeworkDetailRequest.h"

@implementation GetUserHomeworkDetailRequestItem_data
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
@end

@implementation GetUserHomeworkDetailRequestItem
@end

@implementation GetUserHomeworkDetailRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.getUserHomework";
        self.isClient = @"1";
    }
    return self;
}
@end
