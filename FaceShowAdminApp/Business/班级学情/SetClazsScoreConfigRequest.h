//
//  SetClazsScoreConfigRequest.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"

@interface SetClazsScoreConfigRequestItem_data : JSONModel
@end

@interface SetClazsScoreConfigRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) SetClazsScoreConfigRequestItem_data<Optional> *data;
@end

@interface SetClazsScoreConfigRequest : YXPostRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *jsconf;
@end
