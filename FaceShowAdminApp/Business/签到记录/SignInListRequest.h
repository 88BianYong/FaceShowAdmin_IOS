//
//  SignInListRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol SignInListRequestItem_signIns<NSObject>
@end
@interface SignInListRequestItem_signIns: JSONModel
@property (nonatomic, strong) NSString<Optional> *signInId;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *antiCheat;
@property (nonatomic, strong) NSString<Optional> *qrcodeRefreshRate;
@property (nonatomic, strong) NSString<Optional> *successPrompt;
@property (nonatomic, strong) NSString<Optional> *openStatus;
@property (nonatomic, strong) NSString<Optional> *bizId;
@property (nonatomic, strong) NSString<Optional> *bizSource;
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *totalUserNum;
@property (nonatomic, strong) NSString<Optional> *signInUserNum;
@property (nonatomic, strong) NSString<Optional> *opentStatusName;
@property (nonatomic, strong) NSString<Optional> *percent;
@end

@interface SignInListRequestItem_data: JSONModel
@property (nonatomic, strong) NSArray<Optional,SignInListRequestItem_signIns> *signIns;
@end

@interface SignInListRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) SignInListRequestItem_data<Optional> *data;
@end

@interface SignInListRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@end
