//
//  CreateCommentRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface CreateCommentRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *courseId;
@property (nonatomic, copy) NSString<Optional> *clazsId;
@property (nonatomic, copy) NSString<Optional> *commentStatus;
@property (nonatomic, copy) NSString<Optional> *title;
@end
