//
//  NoticeListRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol NoticeListRequestItem_Data_NoticeInfos_Elements @end
@interface NoticeListRequestItem_Data_NoticeInfos_Elements : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *authorId;
@property (nonatomic, strong) NSString<Optional> *clazzId;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *updateTime;
@property (nonatomic, strong) NSString<Optional> *state;
@property (nonatomic, strong) NSString<Optional> *attachUrl;
@property (nonatomic, strong) NSString<Optional> *readNum;
@property (nonatomic, strong) NSString<Optional> *attachName;
@property (nonatomic, strong) NSString<Optional> *authorName;
@property (nonatomic, strong) NSString<Optional> *createTimeStr;
@property (nonatomic, strong) NSString<Optional> *updateTimeStr;
@property (nonatomic, strong) NSString<Optional> *noticeNum;
@property (nonatomic, strong) NSString<Optional> *noticeReadNumSum;
@property (nonatomic, strong) NSString<Optional> *noticeReadUserNum;
@property (nonatomic, strong) NSString<Optional> *viewed;


@end



@interface NoticeListRequestItem_Data_NoticeInfos : JSONModel
@property (nonatomic, strong) NSArray<NoticeListRequestItem_Data_NoticeInfos_Elements,Optional> *elements;
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *pageNum;
@property (nonatomic, strong) NSString<Optional> *offset;
@property (nonatomic, strong) NSString<Optional> *totalElements;
@property (nonatomic, strong) NSString<Optional> *lastPageNumber;
@end

@interface NoticeListRequestItem_Data : JSONModel
@property (nonatomic, strong) NoticeListRequestItem_Data_NoticeInfos *noticeInfos;
@property (nonatomic, strong) NSString *studentNum;
@end

@interface NoticeListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NoticeListRequestItem_Data *data;
@end

@interface NoticeListRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *pageSize;
@end
