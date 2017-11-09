//
//  CourseResourceRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseResourceRequest.h"

@implementation CourseResourceRequestItem_elements
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
@end

@implementation CourseResourceRequestItem_callbacks
@end

@implementation CourseResourceRequestItem_resources
@end

@implementation CourseResourceRequestItem_data
@end

@implementation CourseResourceRequestItem
@end

@implementation CourseResourceRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.manage.resource.courseResources";
    }
    return self;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"callbackId"}];
}
@end
