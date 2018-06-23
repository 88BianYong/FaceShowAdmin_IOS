//
//  UserSignInListRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol UserSignInListRequestItem_elements<NSObject>
@end
@interface UserSignInListRequestItem_elements: JSONModel
@property (nonatomic, strong) NSString<Optional> *signInStatus;
@property (nonatomic, strong) NSString<Optional> *signInTime;
@property (nonatomic, strong) NSString<Optional> *unit;
@property (nonatomic, strong) NSString<Optional> *mobilePhone;
@property (nonatomic, strong) NSString<Optional> *signInDevice;
@property (nonatomic, strong) NSString<Optional> *elementId;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *userId;
@end

@protocol UserSignInListRequestItem_callbacks<NSObject>
@end
@interface UserSignInListRequestItem_callbacks: JSONModel
@property (nonatomic, strong) NSString<Optional> *callbackParam;
@property (nonatomic, strong) NSString<Optional> *callbackValue;
@end

@interface UserSignInListRequestItem_data: JSONModel
@property (nonatomic, strong) NSString<Optional> *totalElements;
@property (nonatomic, strong) NSArray<Optional,UserSignInListRequestItem_elements> *elements;
@property (nonatomic, strong) NSArray<Optional,UserSignInListRequestItem_callbacks> *callbacks;
@end

@interface UserSignInListRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) UserSignInListRequestItem_data<Optional> *data;
@end

@interface UserSignInListRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *status; // 1 for signed, 0 for unsigned
@property (nonatomic, strong) NSString<Optional> *signInTime;
@property (nonatomic, strong) NSString<Optional> *callbackId;
@property (nonatomic, strong) NSString<Optional> *pageSize; // default 20
@end
