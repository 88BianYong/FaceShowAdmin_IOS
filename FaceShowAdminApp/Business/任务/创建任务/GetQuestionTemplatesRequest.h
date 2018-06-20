//
//  GetQuestionTemplatesRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "CreateQuestionGroupItem.h"
@interface GetQuestionTemplatesRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) CreateQuestionGroupItem <Optional> *data;
@end
@interface GetQuestionTemplatesRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *templateId;

@end
