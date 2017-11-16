//
//  DeleteStepRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface DeleteStepRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *stepId;
@end
