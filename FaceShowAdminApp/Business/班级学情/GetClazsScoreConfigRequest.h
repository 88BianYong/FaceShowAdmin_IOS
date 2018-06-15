//
//  GetClazsScoreConfigRequest.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetClazsScoreConfigRequestItem_configItem <NSObject>
@end
@interface GetClazsScoreConfigRequestItem_configItem : JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *scoreType;
@property (nonatomic, strong) NSString<Optional> *scoreDefine;
@property (nonatomic, strong) NSString<Optional> *scoreName;
@property (nonatomic, strong) NSString<Optional> *remark;
@property (nonatomic, strong) NSString<Optional> *status;
@end

@interface GetClazsScoreConfigRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSArray<Optional,GetClazsScoreConfigRequestItem_configItem> *configItems;
@end

@interface GetClazsScoreConfigRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetClazsScoreConfigRequestItem_data<Optional> *data;
@end

@interface GetClazsScoreConfigRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;

@end
