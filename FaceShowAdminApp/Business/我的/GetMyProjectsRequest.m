//
//  GetMyProjectsRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetMyProjectsRequest.h"

@implementation GetMyProjectsRequestItem_project
@end

@implementation GetMyProjectsRequestItem_data
@end

@implementation GetMyProjectsRequestItem
@end

@implementation GetMyProjectsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.project.myProjects";
    }
    return self;
}
@end
