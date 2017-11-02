//
//  ReplenishSignInRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface ReplenishSignInRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *userId; 
@property (nonatomic, strong) NSString<Optional> *signInTime;
@end
