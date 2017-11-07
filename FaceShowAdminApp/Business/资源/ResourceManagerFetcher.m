//
//  ResourceManagerFetcher.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceManagerFetcher.h"
@interface ResourceManagerFetcher ()
@property (nonatomic, strong) ResourceManagerRequest *request;
@end
@implementation ResourceManagerFetcher
- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[ResourceManagerRequest alloc] init];
    self.request.pageSize = [NSString stringWithFormat:@"%@", @(self.pagesize)];
    if (self.lastID != 0) {
        self.request.elementId = [NSString stringWithFormat:@"%@", @(self.lastID)];
    }
    self.request.clazsId = self.clazsId;
    WEAK_SELF
    [self.request startRequestWithRetClass:[ResourceManagerRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        ResourceManagerRequestItem *item = retItem;
        if (item.data.resources.elements.count > 0) {
            BLOCK_EXEC(aCompleteBlock,(int)NSIntegerMax,item.data.resources.elements,nil);
        }else {
            BLOCK_EXEC(aCompleteBlock,0,nil,nil);
        }
        if (item.data.resources.elements.count > 0) {
            self.lastID = [item.data.resources.callbackValue integerValue];
        }
    }];
}
@end
