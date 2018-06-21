//
//  GetUserRolesRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/6/21.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

typedef NS_ENUM(NSUInteger, UserRoleType) {
    UserRole_PlatformAdmin = 500,
    UserRole_AreaAdmin = 480,
    UserRole_ProjectAdmin = 400,
    UserRole_ProjectSteward = 450,
    UserRole_Teacher = 300,
    UserRole_UnknownTeacher = 310,
    UserRole_Student = 200
};

@protocol GetUserRolesRequestItem_roleInfos<NSObject>
@end
@interface GetUserRolesRequestItem_roleInfos:JSONModel
@property (nonatomic, strong) NSString<Optional> *roleId;
@end

@interface GetUserRolesRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<GetUserRolesRequestItem_roleInfos,Optional> *roleInfos;
- (BOOL)roleExists:(UserRoleType)roleType;
@end

@interface GetUserRolesRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetUserRolesRequestItem_data<Optional> *data;
@end

@interface GetUserRolesRequest : YXGetRequest
@property (nonatomic, strong) NSString *platId;
@end
