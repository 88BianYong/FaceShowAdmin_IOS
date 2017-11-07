//
//  ClassUserQuestionFetcher.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassUserQuestionFetcher.h"
#import "ClassUserQuestionRequest.h"

@interface ClassUserQuestionFetcher()
@property (nonatomic, strong) ClassUserQuestionRequest *request;
@property (nonatomic, strong) NSString<Optional> *callbackId;
@property (nonatomic, strong) NSString<Optional> *pre_callbackId;
@end

@implementation ClassUserQuestionFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[ClassUserQuestionRequest alloc]init];
    self.request.stepId = self.stepId;
    self.request.status = self.status;
    self.request.callbackId = self.callbackId;
    WEAK_SELF
    [self.request startRequestWithRetClass:[ClassUserQuestionRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        ClassUserQuestionRequestItem *item = (ClassUserQuestionRequestItem *)retItem;
        ClassUserQuestionRequestItem_callbacks *callback1 = item.data.callbacks.firstObject;
        self.callbackId = callback1.callbackValue;
        if (self.request.callbackId && item.data.elements.count==0) {
            BLOCK_EXEC(self.noMoreBlock);
        }
        BLOCK_EXEC(aCompleteBlock,99999,item.data.elements,nil);
    }];
}

#pragma mark - PageListRequestDelegate
- (void)requestWillRefresh {
    self.pre_callbackId = self.callbackId;
    self.callbackId = nil;
}
- (void)requestEndRefreshWithError:(NSError *)error {
    if (error) {
        self.callbackId = self.pre_callbackId;
    }
}

@end
