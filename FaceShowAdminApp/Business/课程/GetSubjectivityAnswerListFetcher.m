//
//  GetSubjectivityAnswerListFetcher.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetSubjectivityAnswerListFetcher.h"

@interface GetSubjectivityAnswerListFetcher ()
@property (nonatomic, strong) GetSubjectivityAnswerReuqest *request;
@end

@implementation GetSubjectivityAnswerListFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[GetSubjectivityAnswerReuqest alloc]init];
    self.request.questionId = self.questionId;
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetSubjectivityAnswerItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        GetSubjectivityAnswerItem *item = (GetSubjectivityAnswerItem *)retItem;
        BLOCK_EXEC(aCompleteBlock,999999,item.data,nil);
    }];
}
@end
