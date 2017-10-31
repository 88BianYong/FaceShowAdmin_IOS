//
//  SignInListFetcher.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInListFetcher.h"
#import "SignInListRequest.h"

@interface SignInListFetcher()
@property (nonatomic, strong) SignInListRequest *request;
@end

@implementation SignInListFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[SignInListRequest alloc]init];
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
