//
//  ReviewUserHomeworkRequest.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface ReviewUserHomeworkRequest : YXGetRequest
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) NSString *userHomeworkId;
@property (nonatomic, strong) NSString *finishStatus;
@property (nonatomic, strong) NSString *assess;
@end
