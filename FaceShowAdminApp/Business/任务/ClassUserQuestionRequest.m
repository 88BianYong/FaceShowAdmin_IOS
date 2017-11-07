//
//  ClassUserQuestionRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassUserQuestionRequest.h"

@implementation ClassUserQuestionRequestItem_elements
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
@end

@implementation ClassUserQuestionRequestItem_callbacks
@end

@implementation ClassUserQuestionRequestItem_data
@end

@implementation ClassUserQuestionRequestItem
@end

@implementation ClassUserQuestionRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.clazsUserQuestion";
    }
    return self;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"callbackId"}];
}

@end
