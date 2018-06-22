//
//  GetUserHomeworksRequest.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "GetHomeworkRequest.h"

@protocol GetUserHomeworksRequestItem_element <NSObject>
@end
@interface GetUserHomeworksRequestItem_element : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *homeworkId;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *resourceKey;
@property (nonatomic, strong) NSString<Optional> *resourceSource;
@property (nonatomic, strong) NSString<Optional> *submitTime;
@property (nonatomic, strong) NSString<Optional> *finishStatus;//1-审核通过  2-审核未通过 
@property (nonatomic, strong) NSString<Optional> *assess;
@property (nonatomic, strong) NSArray<Optional,GetHomeworkRequestItem_attachmentInfo> *attachmentInfos;

@end

@interface GetUserHomeworksRequestItem_userHomeworks : JSONModel
@property (nonatomic, strong) NSArray<Optional,GetUserHomeworksRequestItem_element> *elements;
@end

@interface GetUserHomeworksRequestItem_data : JSONModel
@property (nonatomic, strong) GetUserHomeworksRequestItem_userHomeworks<Optional> *userHomeworks;
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *pageNum;
@property (nonatomic, strong) NSString<Ignore> *offset;
@property (nonatomic, strong) NSString<Optional> *totalElements;
@property (nonatomic, strong) NSString<Ignore> *lastPageNumber;
@end

@interface GetUserHomeworksRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetUserHomeworksRequestItem_data<Optional> *data;
@end

@interface GetUserHomeworksRequest : YXGetRequest
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) NSString *isFinished;
@property (nonatomic, strong) NSString<Optional> *offset;
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *orderBy;//排序：可以多字段排序 例如 create_time desc,status asc
@property (nonatomic, strong) NSString<Optional> *isClient;//是否是客户端， true false
@end
