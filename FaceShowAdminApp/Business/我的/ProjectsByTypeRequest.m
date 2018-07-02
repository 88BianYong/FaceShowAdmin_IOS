//
//  ProjectsByTypeRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/8/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ProjectsByTypeRequest.h"

@implementation ProjectsByTypeRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"project.getProjectsByType";
    }
    return self;
}
@end
