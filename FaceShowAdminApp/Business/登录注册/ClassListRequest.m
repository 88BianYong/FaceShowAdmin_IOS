//
//  ClassListRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassListRequest.h"

@implementation ClassListRequestItem_clazsInfos
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"clazsId",@"description":@"desc"}];
}
@end

@implementation ClassListRequestItem_data
@end

@implementation ClassListRequestItem
@end

@implementation ClassListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.manage.clazses";
    }
    return self;
}
@end
