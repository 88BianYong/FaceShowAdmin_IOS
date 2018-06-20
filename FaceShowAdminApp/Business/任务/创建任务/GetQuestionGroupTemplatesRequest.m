//
//  GetQuestionGroupTemplatesRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetQuestionGroupTemplatesRequest.h"
@implementation GetQuestionGroupTemplatesRequestItem_Data
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"templateId",@"description":@"desc"}];
}
@end
@implementation GetQuestionGroupTemplatesRequestItem
@end
@implementation GetQuestionGroupTemplatesRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.getQuestionGroupTemplates";
    }
    return self;
}
@end
