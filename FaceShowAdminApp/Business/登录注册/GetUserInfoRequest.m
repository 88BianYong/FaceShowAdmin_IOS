//
//  GetUserInfoRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetUserInfoRequest.h"

@implementation GetUserInfoRequestItem_Data
- (NSString *)sexString {
    return self.sex.integerValue ? @"男" : @"女";
}
@end

@implementation GetUserInfoRequestItem
@end

@implementation GetUserInfoRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.sysUser.userInfo";
    }
    return self;
}
@end
