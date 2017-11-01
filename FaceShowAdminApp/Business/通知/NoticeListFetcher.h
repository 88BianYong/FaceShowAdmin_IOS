//
//  NoticeListFetcher.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "NoticeListRequest.h"
@interface NoticeListFetcher : PagedListFetcherBase
@property (nonatomic, copy) NSString<Optional> *clazsId;
@property (nonatomic, copy) void(^noticeStudentNum)(NSString *number);
@end
