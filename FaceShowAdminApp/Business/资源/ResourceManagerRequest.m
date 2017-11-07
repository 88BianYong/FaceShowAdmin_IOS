//
//  ResourceManagerRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceManagerRequest.h"
@implementation ResourceManagerRequestItem_Data_Resources_Elements
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
@end

@implementation ResourceManagerRequestItem_Data_Resources
@end

@implementation ResourceManagerRequestItem_Data
@end

@implementation ResourceManagerRequestItem
@end

@implementation ResourceManagerRequest
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.manage.resource.clazsResources";
    }
    return self;
}
@end
