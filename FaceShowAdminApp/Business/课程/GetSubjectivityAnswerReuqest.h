//
//  GetSubjectivityAnswerReuqest.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetsubjectivityAnswer_Element <NSObject>
@end
@interface GetsubjectivityAnswer_Element : JSONModel
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *answer;
@property (nonatomic, strong) NSString<Optional> *questionId;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *avatar;
@end

@interface GetSubjectivityAnswerItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetsubjectivityAnswer_Element, Optional> *data;
@end

@interface GetSubjectivityAnswerReuqest : YXGetRequest
@property (nonatomic, strong) NSString *questionId;
@end
