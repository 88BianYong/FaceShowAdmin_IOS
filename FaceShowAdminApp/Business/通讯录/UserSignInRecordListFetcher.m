//
//  UserSignInRecordListFetcher.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserSignInRecordListFetcher.h"
#import "SignInListRequest.h"

@interface UserSignInRecordListFetcher()
@property (nonatomic, strong) SignInListRequest *request;
@end

@implementation UserSignInRecordListFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[SignInListRequest alloc]init];
    self.request.method = @"app.manage.clazsuser.signIns";
    self.request.userId = self.userId;
    WEAK_SELF
    [self.request startRequestWithRetClass:[SignInListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        SignInListRequestItem *item = (SignInListRequestItem *)retItem;
        BLOCK_EXEC(aCompleteBlock,0,item.data.signIns,nil);
    }];
}
@end
