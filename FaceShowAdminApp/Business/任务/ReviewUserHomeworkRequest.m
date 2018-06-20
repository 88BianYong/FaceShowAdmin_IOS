//
//  ReviewUserHomeworkRequest.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ReviewUserHomeworkRequest.h"

@implementation ReviewUserHomeworkRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.reviewUserHomework";
    }
    return self;
}
@end
