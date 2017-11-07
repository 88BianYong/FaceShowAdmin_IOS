//
//  ResourceCreateRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceCreateRequest.h"
@implementation ResourceCreateRequestItem
@end
@implementation ResourceCreateRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = @"http://api.rms.yanxiu.com/resource/create";
        self.from_flow = @"6";
    }
    return self;
}
@end
