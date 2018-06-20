//
//  GetTaskCommentRequest.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetTaskCommentRequestItem_element <NSObject>
@end
@interface GetTaskCommentRequestItem_element : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *anonymous;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *replyNum;
@property (nonatomic, strong) NSString<Optional> *likeNum;
@property (nonatomic, strong) NSString<Optional> *replyCommentRecordId;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *commentId;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *replays;
@property (nonatomic, strong) NSString<Optional> *userLiked;
@end

@interface GetTaskCommentRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<Optional,GetTaskCommentRequestItem_element> *elements;
@property (nonatomic, strong) NSString<Optional> *callbackParam;
@property (nonatomic, strong) NSString<Optional> *callbackValue;
@property (nonatomic, strong) NSString<Optional> *totalElements;

@property (nonatomic, strong) NSString<Ignore> *title;
@end

@interface GetTaskCommentRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetTaskCommentRequestItem_data<Optional> *data;
@end

@interface GetTaskCommentRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *callbackValue;
@property (nonatomic, strong) NSString<Optional> *limit;
@property (nonatomic, strong) NSString<Optional> *order;
@end

