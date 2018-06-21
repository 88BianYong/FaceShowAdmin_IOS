//
//  SetClazsScoreConfigRequest.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"

@interface SetClazsScoreConfigRequestItem_undefinedConfig : JSONModel
@end

@interface SetClazsScoreConfigRequestItem_data : JSONModel
@property (nonatomic, strong) SetClazsScoreConfigRequestItem_undefinedConfig<Optional> *undefined_config;
@end

@interface SetClazsScoreConfigRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) SetClazsScoreConfigRequestItem_data<Optional> *data;
@end

@interface SetClazsScoreConfigRequest : YXPostRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *jsconf;//json串的配置项。注意每次传全量配置项，否则缺失的配置项会被默认覆盖json格式：[{"scoreType":取自接口1中type,"scoreDefine":分值，只能是整数 }]
@end
