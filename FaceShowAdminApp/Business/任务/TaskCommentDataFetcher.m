//
//  TaskCommentDataFetcher.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TaskCommentDataFetcher.h"
#import "GetTaskCommentTitleRequest.h"

@interface TaskCommentDataFetcher()
@property (nonatomic, strong) GetTaskCommentRequest *request;
@property (nonatomic, strong) GetTaskCommentTitleRequest *titleRequest;
@property (nonatomic, strong) NSString *title;
@end

@implementation TaskCommentDataFetcher

- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.titleRequest stopRequest];
    self.titleRequest = [[GetTaskCommentTitleRequest alloc]init];
    self.titleRequest.stepId = self.stepId;
    WEAK_SELF
    [self.titleRequest startRequestWithRetClass:[GetTaskCommentTitleRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        GetTaskCommentTitleRequestItem *item = (GetTaskCommentTitleRequestItem *)retItem;
        self.title = item.data.title;
        [self requestCommentsWithCompleteBlock:aCompleteBlock];
    }];
}

- (void)requestCommentsWithCompleteBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[GetTaskCommentRequest alloc]init];
    self.request.stepId = self.stepId;
    if (self.lastID != 0) {
        self.request.callbackValue = [NSString stringWithFormat:@"%@",@(self.lastID)];
    }
    self.request.limit = [NSString stringWithFormat:@"%@",@(self.pagesize)];
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetTaskCommentRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        GetTaskCommentRequestItem *item = (GetTaskCommentRequestItem *)retItem;
        item.data.title = self.title;
        BLOCK_EXEC(self.finishBlock,retItem);
        BLOCK_EXEC(aCompleteBlock,999999,item.data.elements,nil);
        if (item.data.elements.count > 0) {
            GetTaskCommentRequestItem_element *element = [item.data.elements lastObject];
            self.lastID = element.elementId.integerValue;
        }
    }];
}

@end

