//
//  ProjectDetailRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ProjectDetailRequest.h"

@implementation ProjectDetailRequestItem_clazs
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"clazsId"}];
}
@end
@implementation ProjectDetailRequestItem_projectCount
@end
@implementation ProjectDetailRequestItem_data
@end
@implementation ProjectDetailRequestItem
@end

@implementation ProjectDetailRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.project.projectDetail";
    }
    return self;
}
@end
