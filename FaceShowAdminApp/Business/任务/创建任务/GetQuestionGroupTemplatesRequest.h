//
//  GetQuestionGroupTemplatesRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol GetQuestionGroupTemplatesRequestItem_Data @end
@interface GetQuestionGroupTemplatesRequestItem_Data : JSONModel
@property (nonatomic, copy) NSString<Optional> *templateId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *templateType;
@end
@interface GetQuestionGroupTemplatesRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetQuestionGroupTemplatesRequestItem_Data,Optional> *data;
@end
@interface GetQuestionGroupTemplatesRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *clazsId;
@end
