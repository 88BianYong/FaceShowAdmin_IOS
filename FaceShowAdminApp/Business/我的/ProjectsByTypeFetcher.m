//
//  ProjectsByTypeFetcher.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/8/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ProjectsByTypeFetcher.h"
#import "ProjectsByTypeRequest.h"
@interface ProjectsByTypeFetcher()
@property (nonatomic, strong) ProjectsByTypeRequest *request;
@end

@implementation ProjectsByTypeFetcher
- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[ProjectsByTypeRequest alloc] init];
    GetUserPlatformRequestItem_platformInfos *plat = [UserManager sharedInstance].userModel.platformRequestItem.data.platformInfos.firstObject;
    self.request.platId = plat.platformId;
    self.request.pageSize = @"10";
    self.request.offset = [NSString stringWithFormat:@"%@", @(self.lastID)];
    self.request.startTime = self.startTime;
    self.request.endTime = self.endTime;
    
    self.request.projectQueryType = self.projectQueryType;
    self.request.projectQueryTypeValue = self.projectQueryTypeValue;
    
    self.request.provinceId = self.provinceId;
    self.request.cityId = self.cityId;
    self.request.districtId = self.districtId;

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
