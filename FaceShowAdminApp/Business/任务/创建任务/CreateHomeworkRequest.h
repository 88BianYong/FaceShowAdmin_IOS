//
//  CreateHomeworkRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface CreateHomeworkRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *courseId;
@property (nonatomic, copy) NSString<Optional> *clazsId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *resourceKey;
@end
