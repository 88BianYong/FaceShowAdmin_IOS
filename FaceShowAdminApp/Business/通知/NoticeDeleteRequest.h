//
//  NoticeDeleteRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface NoticeDeleteRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *noticeId;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@end
