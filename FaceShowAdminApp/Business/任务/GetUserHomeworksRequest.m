//
//  GetUserHomeworksRequest.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetUserHomeworksRequest.h"

@implementation GetUserHomeworksRequestItem_element
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
@end

@implementation GetUserHomeworksRequestItem_userHomeworks
@end

@implementation GetUserHomeworksRequestItem_data
@end

@implementation GetUserHomeworksRequestItem
@end

@implementation GetUserHomeworksRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.getUserHomeworks";
    }
    return self;
}

@end
