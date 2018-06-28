//
//  ResourceGenerateRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ResourceGenerateRequest.h"
#import "QiniuConfig.h"

@implementation ResourceGenerateRequestItem_data
@end

@implementation ResourceGenerateRequestItem
@end

@implementation ResourceGenerateRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kQiniuServer;
        self.method = @"upload.upinfo";
    }
    return self;
}
@end
