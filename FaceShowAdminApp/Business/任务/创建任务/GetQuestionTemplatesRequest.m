//
//  GetQuestionTemplatesRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetQuestionTemplatesRequest.h"
@implementation GetQuestionTemplatesRequestItem
@end
@implementation GetQuestionTemplatesRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.getQuestionTemplates";
    }
    return self;
}
@end
