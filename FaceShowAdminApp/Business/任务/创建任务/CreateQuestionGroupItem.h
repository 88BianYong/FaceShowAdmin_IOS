//
//  CreateQuestionGroupItem.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "JSONModel.h"
@protocol CreateQuestionGroupItem_Question_VoteInfo_VoteItem @end
@interface CreateQuestionGroupItem_Question_VoteInfo_VoteItem : JSONModel
@property (nonatomic, copy) NSString<Optional> *itemName;
@end

@protocol CreateQuestionGroupItem_Question_VoteInfo @end
@interface CreateQuestionGroupItem_Question_VoteInfo : JSONModel
@property (nonatomic, copy) NSString<Optional> *maxSelectNum;
@property (nonatomic, strong) NSMutableArray<CreateQuestionGroupItem_Question_VoteInfo_VoteItem, Optional> *voteItems;
@end

@protocol CreateQuestionGroupItem_Question @end
@interface CreateQuestionGroupItem_Question : JSONModel
@property (nonatomic, copy) NSString<Optional> *questionId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *questionType;//：1-单选 2-多选 3-主观题
@property (nonatomic, strong) CreateQuestionGroupItem_Question_VoteInfo<Optional> *voteInfo;
@end
@interface CreateQuestionGroupItem : JSONModel
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, strong) NSMutableArray<CreateQuestionGroupItem_Question, Optional> *questions;
@end
