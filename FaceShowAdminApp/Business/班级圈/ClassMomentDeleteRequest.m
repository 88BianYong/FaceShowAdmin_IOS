//
//  ClassMomentDeleteRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassMomentDeleteRequest.h"

@implementation ClassMomentDeleteRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"moment.deleteMoment";
    }
    return self;
}
@end
