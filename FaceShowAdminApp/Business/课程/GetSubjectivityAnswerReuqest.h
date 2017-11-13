//
//  GetSubjectivityAnswerReuqest.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetSubjectivityAnswer_Element <NSObject>
@end
@interface GetSubjectivityAnswer_Element : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *answer;
@property (nonatomic, strong) NSString<Optional> *questionId;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *createTime;
@end

@interface GetSubjectivityAnswerItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetSubjectivityAnswer_Element, Optional> *data;
@property (nonatomic, strong) NSString<Optional> *currentTime;
@end

@interface GetSubjectivityAnswerReuqest : YXGetRequest
@property (nonatomic, strong) NSString *questionId;
@end
