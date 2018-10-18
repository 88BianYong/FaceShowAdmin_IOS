//
//  UpdateSignInRequest.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UpdateSignInRequest : YXPostRequest
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *endTime;
@property (nonatomic, strong) NSString<Optional> *antiCheat;
@property (nonatomic, strong) NSString<Optional> *qrcodeRefreshRate;
@property (nonatomic, strong) NSString<Optional> *signinPosition;
@property (nonatomic, strong) NSString<Optional> *positionRange;
@property (nonatomic, strong) NSString<Optional> *positionSite;
@property (nonatomic, strong) NSString<Optional> *successPrompt;
@property (nonatomic, strong) NSString<Optional> *signinExts;
@property (nonatomic, strong) NSString<Optional> *signinType;
@end

NS_ASSUME_NONNULL_END
