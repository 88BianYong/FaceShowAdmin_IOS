//
//  GroupListRequest.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GroupListRequest.h"

@implementation GroupListRequest_Item_groups
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"groupsId"}];
}
@end

@implementation GroupListRequest_Item_data
@end

@implementation GroupListRequest_Item
@end

@implementation GroupListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.manage.group.list";
    }
    return self;
}
@end
