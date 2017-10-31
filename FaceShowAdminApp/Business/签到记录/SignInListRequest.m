//
//  SignInListRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInListRequest.h"

@implementation SignInListRequestItem_signIns
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"signInId"}];
}
@end

@implementation SignInListRequestItem_data
@end

@implementation SignInListRequestItem
@end

@implementation SignInListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.manage.clazs.signIns";
        self.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    }
    return self;
}
@end
