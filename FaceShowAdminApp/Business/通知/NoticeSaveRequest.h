//
//  NoticeSaveRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "NoticeListRequest.h"
@interface NoticeSaveRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NoticeListRequestItem_Data_NoticeInfos_Elements *data;

@end

@interface NoticeSaveRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *url;
@end
