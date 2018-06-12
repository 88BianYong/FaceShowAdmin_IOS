//
//  UpdateComplexRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface UpdateComplexRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *stepId;
@property (nonatomic, copy) NSString<Optional> *questionGroup;
@property (nonatomic, copy) NSString<Optional> *isUsed;

@end
