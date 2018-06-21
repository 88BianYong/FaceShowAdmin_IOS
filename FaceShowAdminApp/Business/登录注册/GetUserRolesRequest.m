//
//  GetUserRolesRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/6/21.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetUserRolesRequest.h"

@implementation GetUserRolesRequestItem_roleInfos
@end

@implementation GetUserRolesRequestItem_data
- (BOOL)roleExists:(UserRoleType)roleType {
    for (GetUserRolesRequestItem_roleInfos *role in self.roleInfos) {
        if (role.roleId.integerValue == roleType) {
            return YES;
        }
    }
    return NO;
}
@end

@implementation GetUserRolesRequestItem

@end

@implementation GetUserRolesRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.platform.getUserRoles";
    }
    return self;
}
@end
