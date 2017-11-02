//
//  UserSignInListRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserSignInListRequest.h"

@implementation UserSignInListRequestItem_elements
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
@end

@implementation UserSignInListRequestItem_callbacks
@end

@implementation UserSignInListRequestItem_data
@end

@implementation UserSignInListRequestItem
@end

@implementation UserSignInListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.clazsUserSignIn";
    }
    return self;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"callbackId"}];
}

@end
