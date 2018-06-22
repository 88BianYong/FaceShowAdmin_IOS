//
//  GetUserHomeworkDetailRequest.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "GetHomeworkRequest.h"

@interface GetUserHomeworkDetailRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *homeworkId;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *resourceKey;
@property (nonatomic, strong) NSString<Optional> *resourceSource;
@property (nonatomic, strong) NSString<Optional> *submitTime;
@property (nonatomic, strong) NSString<Optional> *finishStatus;//1-审核通过  2-审核未通过  3-已提交未审核
@property (nonatomic, strong) NSString<Optional> *assess;
@property (nonatomic, strong) NSArray<Optional,GetHomeworkRequestItem_attachmentInfo> *attachmentInfos;
@end

@interface GetUserHomeworkDetailRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetUserHomeworkDetailRequestItem_data<Optional> *data;
@end

@interface GetUserHomeworkDetailRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *userHomeworkId;
@property (nonatomic, strong) NSString<Optional> *isClient;//是否为app： 1-app 0-pc
@end
