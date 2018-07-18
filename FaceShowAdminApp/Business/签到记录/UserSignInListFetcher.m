//
//  UserSignInListFetcher.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserSignInListFetcher.h"
#import "UserSignInListRequest.h"

@interface UserSignInListFetcher()
@property (nonatomic, strong) UserSignInListRequest *request;
@property (nonatomic, strong) NSString<Optional> *signInTime;
@property (nonatomic, strong) NSString<Optional> *callbackId;
@property (nonatomic, strong) NSString<Optional> *pre_signInTime;
@property (nonatomic, strong) NSString<Optional> *pre_callbackId;
@end

@implementation UserSignInListFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[UserSignInListRequest alloc]init];
    self.request.stepId = self.stepId;
    self.request.status = self.status;
    self.request.signInTime = self.signInTime;
    self.request.callbackId = self.callbackId;
    WEAK_SELF
    [self.request startRequestWithRetClass:[UserSignInListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        UserSignInListRequestItem *item = (UserSignInListRequestItem *)retItem;
        UserSignInListRequestItem_callbacks *callback1 = item.data.callbacks.lastObject;
        self.signInTime = callback1.callbackValue;
        UserSignInListRequestItem_callbacks *callback2 = item.data.callbacks.lastObject;
        self.callbackId = callback2.callbackValue;
        if (self.request.callbackId && item.data.elements.count==0) {
            BLOCK_EXEC(self.noMoreBlock);
        }
        BLOCK_EXEC(aCompleteBlock,isEmpty(item.data.callbacks)? 0:99999,item.data.elements,nil);
    }];
}

#pragma mark - PageListRequestDelegate
- (void)requestWillRefresh {
    self.pre_callbackId = self.callbackId;
    self.pre_signInTime = self.signInTime;
    self.callbackId = nil;
    self.signInTime = nil;
}

- (void)requestEndRefreshWithError:(NSError *)error {
    if (error) {
        self.signInTime = self.pre_signInTime;
        self.callbackId = self.pre_callbackId;
    }
}

@end
