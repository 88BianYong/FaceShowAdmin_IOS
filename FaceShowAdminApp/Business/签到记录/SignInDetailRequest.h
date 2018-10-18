//
//  SignInDetailRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "SignInListRequest.h"


@protocol SignInDetailRequest_Item_signInExts <NSObject> @end
@interface SignInDetailRequest_Item_signInExts : JSONModel
@property (nonatomic, strong) NSString<Optional> *signinPosition;
@property (nonatomic, strong) NSString<Optional> *positionSite;
@property (nonatomic, strong) NSString<Optional> *positionRange;
@property (nonatomic, strong) NSString<Optional> *groupId;
@end

@interface SignInDetailRequestItem_data_signIns : SignInListRequestItem_signIns
@property (nonatomic, strong) NSArray<SignInDetailRequest_Item_signInExts,Optional> *signInExts;
@end

@interface SignInDetailRequestItem_data: JSONModel
@property (nonatomic, strong) NSString<Optional> *interactType;
@property (nonatomic, strong) SignInDetailRequestItem_data_signIns<Optional> *signIn;
@end

@interface SignInDetailRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) SignInDetailRequestItem_data<Optional> *data;
@end

@interface SignInDetailRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *stepId;
@end
