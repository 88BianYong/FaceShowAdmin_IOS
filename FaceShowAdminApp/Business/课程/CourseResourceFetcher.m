//
//  CourseResourceFetcher.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseResourceFetcher.h"
#import "CourseResourceRequest.h"

@interface CourseResourceFetcher()
@property (nonatomic, strong) CourseResourceRequest *request;
@end

@implementation CourseResourceFetcher
- (void)startWithBlock:(void (^)(int, NSArray *, NSError *))aCompleteBlock {
    [self.request stopRequest];
    self.request = [[CourseResourceRequest alloc]init];
    self.request.courseId = self.courseId;
    self.request.pageSize = @"999999";
    WEAK_SELF
    [self.request startRequestWithRetClass:[CourseResourceRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        CourseResourceRequestItem *item = (CourseResourceRequestItem *)retItem;
        BLOCK_EXEC(aCompleteBlock,0,item.data.resources.elements,nil);
    }];
}

@end
