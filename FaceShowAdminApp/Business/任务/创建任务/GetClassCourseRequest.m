//
//  GetClassCourseRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetClassCourseRequest.h"
@implementation GetClassCourseRequestItem_Data
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"courseId"}];
}
@end
@implementation GetClassCourseRequestItem
@end
@implementation GetClassCourseRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"clazs.getCourses";
    }
    return self;
}
@end
