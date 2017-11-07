//
//  ResourceUploadRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceUploadRequest.h"

@implementation ResourceUploadRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"resource.save";
    }
    return self;
}
@end
