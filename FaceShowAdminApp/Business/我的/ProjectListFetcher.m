//
//  ProjectListFetcher.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/8/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ProjectListFetcher.h"
#import "ProjectListRequest.h"

@interface ProjectListFetcher()
@property (nonatomic, strong) ProjectListRequest *request;
@end

@implementation ProjectListFetcher
- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[ProjectListRequest alloc] init];
    GetUserPlatformRequestItem_platformInfos *plat = [UserManager sharedInstance].userModel.platformRequestItem.data.platformInfos.firstObject;
    self.request.platId = plat.platformId;
    self.request.pageSize = @"10";
    self.request.offset = [NSString stringWithFormat:@"%@", @(self.lastID)];
    WEAK_SELF
    [self.request startRequestWithRetClass:[ProjectListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        ProjectListRequestItem *item = retItem;
        BLOCK_EXEC(aCompleteBlock,item.data.projectPage.totalElements.intValue,item.data.projectPage.elements,nil);
        self.lastID += item.data.projectPage.elements.count;
    }];
}
@end
