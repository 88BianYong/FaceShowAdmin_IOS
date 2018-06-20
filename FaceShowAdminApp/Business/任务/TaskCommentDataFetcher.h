//
//  TaskCommentDataFetcher.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "GetTaskCommentRequest.h"

@interface TaskCommentDataFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) void(^finishBlock) (GetTaskCommentRequestItem *item);
@end
