//
//  GetTaskCommentRequest.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetTaskCommentRequest.h"

@implementation GetTaskCommentRequestItem_element
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
@end

@implementation GetTaskCommentRequestItem_data

@end

@implementation GetTaskCommentRequestItem

@end

@implementation GetTaskCommentRequest
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"callbackValue"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.interact.commentRecords";
    }
    return self;
}
@end
