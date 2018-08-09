//
//  ProjectListRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/8/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ProjectListRequest.h"

@implementation ProjectListRequestItem
@end

@implementation ProjectListRequestItem_data
@end

@implementation ProjectListRequestItem_projectPage
@end

@implementation ProjectListRequestItem_elements
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementID"}];
}
@end

@implementation ProjectListRequestItem_projectScopeList
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"projectScopeID"}];
}
@end

@implementation ProjectListRequestItem_institutionInfo
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"institutionID"}];
}
@end

@implementation ProjectListRequestItem_managerScopeList
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"managerScopeID"}];
}
@end

@implementation ProjectListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.platform.getManagerProjects";
    }
    return self;
}
@end
