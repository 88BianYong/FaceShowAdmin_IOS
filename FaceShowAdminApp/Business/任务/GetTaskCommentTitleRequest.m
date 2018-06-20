//
//  GetTaskCommentTitleRequest.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetTaskCommentTitleRequest.h"

@implementation GetTaskCommentTitleRequestItem_data
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"desc"}];
}
@end

@implementation GetTaskCommentTitleRequestItem

@end

@implementation GetTaskCommentTitleRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.interact.getComment";
    }
    return self;
}

@end
