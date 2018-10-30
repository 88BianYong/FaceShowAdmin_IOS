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

- (BOOL)isUnknownRole {
    for (GetUserRolesRequestItem_roleInfos *role in self.roleInfos) {
        if (role.roleId.integerValue == UserRole_PlatformAdmin||
            role.roleId.integerValue == UserRole_PlatAdmin||
            role.roleId.integerValue == UserRole_ProjectAdmin||
            role.roleId.integerValue == UserRole_ProjectSteward||
            role.roleId.integerValue == UserRole_ProvinceAdmin||
            role.roleId.integerValue == UserRole_Teacher||
            role.roleId.integerValue == UserRole_UnknownTeacher) {
            return NO;
        }
    }
    return YES;
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
