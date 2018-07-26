//
//  UserHomeworkFetcher.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "UserHomeworkFetcher.h"
#import "GetUserHomeworksRequest.h"

@interface UserHomeworkFetcher ()
@property (nonatomic, strong) GetUserHomeworksRequest *request;
@end
@implementation UserHomeworkFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[GetUserHomeworksRequest alloc] init];
    self.request.offset = [NSString stringWithFormat:@"%@",@(self.lastID)];
    self.request.pageSize = [NSString stringWithFormat:@"%@",@(self.pagesize)];
    self.request.stepId = self.stepId;
    self.request.isFinished = self.isFinished;
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetUserHomeworksRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error)
            return;
        }
        GetUserHomeworksRequestItem *item = (GetUserHomeworksRequestItem *)retItem;
        self.lastID += item.data.userHomeworks.elements.count;
        BLOCK_EXEC(aCompleteBlock, item.data.userHomeworks.totalElements.intValue, item.data.userHomeworks.elements, nil)
    }];
}
@end
