//
//  SignInDetailRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "SignInListRequest.h"

@interface SignInDetailRequestItem_data: JSONModel
@property (nonatomic, strong) NSString<Optional> *interactType;
@property (nonatomic, strong) SignInListRequestItem_signIns<Optional> *signIn;
@end

@interface SignInDetailRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) SignInDetailRequestItem_data<Optional> *data;
@end

@interface SignInDetailRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *stepId;
@end
