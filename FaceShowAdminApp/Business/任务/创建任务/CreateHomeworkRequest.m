//
//  CreateHomeworkRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateHomeworkRequest.h"

@implementation CreateHomeworkRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.createHomework";
    }
    return self;
}
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"desc"}];
}
@end
