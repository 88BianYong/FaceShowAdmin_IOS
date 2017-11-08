//
//  UserSignInPercentRequest.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface UserSignInPercentRequestItem_Data : JSONModel
@property (nonatomic, strong) NSString<Optional> *userSigninNum;
@property (nonatomic, strong) NSString<Optional> *signinPercent;
@property (nonatomic, strong) NSString<Optional> *totalSigninNum;
@end

@interface UserSignInPercentRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) UserSignInPercentRequestItem_Data<Optional> *data;
@end

@interface UserSignInPercentRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@property (nonatomic, strong) NSString *userId;
@end
