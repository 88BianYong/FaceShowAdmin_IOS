//
//  NoticeListFetcher.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeListFetcher.h"
@interface NoticeListFetcher ()
@property (nonatomic, strong) NoticeListRequest *request;
@end
@implementation NoticeListFetcher
- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[NoticeListRequest alloc] init];
    self.request.pageSize = [NSString stringWithFormat:@"%@", @(self.pagesize)];
    if (self.lastID != 0) {
        self.request.elementId = [NSString stringWithFormat:@"%@", @(self.lastID)];
    }
    self.request.clazsId = self.clazsId;
    WEAK_SELF
    [self.request startRequestWithRetClass:[NoticeListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        NoticeListRequestItem *item = retItem;
        if (item.data.noticeInfos.elements.count > 0) {
            BLOCK_EXEC(aCompleteBlock,(int)NSIntegerMax,item.data.noticeInfos.elements,nil);
            BLOCK_EXEC(self.noticeStudentNum,item.data.studentNum);
        }else {
            BLOCK_EXEC(aCompleteBlock,0,nil,nil);
        }
        if (item.data.noticeInfos.elements.count > 0) {
            NoticeListRequestItem_Data_NoticeInfos_Elements *element = [item.data.noticeInfos.elements lastObject];
            self.lastID = element.elementId.integerValue;
        }
    }];
}
@end
