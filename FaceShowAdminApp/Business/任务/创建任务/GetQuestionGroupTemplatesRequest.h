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
@property (nonatomic, copy) NSString<Optional> *templateType;//1-班级模板   2-课程模板   3-课程讲师评价模板    9-通用模板（既可以作为班级模板也可以作为课程模板）
@end
@interface GetQuestionGroupTemplatesRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetQuestionGroupTemplatesRequestItem_Data,Optional> *data;
@end
@interface GetQuestionGroupTemplatesRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *clazsId;
@property (nonatomic, copy) NSString<Optional> *interactType;//3-投票 5-问卷 7-评价
@end
