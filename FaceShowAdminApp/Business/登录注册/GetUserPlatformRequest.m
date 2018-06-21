//
//  GetUserPlatformRequest.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/6/21.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetUserPlatformRequest.h"

@implementation GetUserPlatformRequestItem_platformInfos
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"platformId"}];
}
@end

@implementation GetUserPlatformRequestItem_data

@end

@implementation GetUserPlatformRequestItem

@end

@implementation GetUserPlatformRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.platform.getUserPlatforms";
    }
    return self;
}
@end
