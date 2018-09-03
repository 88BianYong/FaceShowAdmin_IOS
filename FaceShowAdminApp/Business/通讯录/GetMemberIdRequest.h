//
//  GetMemberIdRequest.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/9/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

//http://wiki.yanxiu.com/pages/viewpage.action?pageId=12326677#id-用户、登录接口-1.3获取用户在im的id


@interface GetMemberIdRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *memberId;
@end

@interface GetMemberIdRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetMemberIdRequestItem_data<Optional> *data;
@end

@interface GetMemberIdRequest : YXGetRequest
@property (nonatomic, strong) NSString *userId;
@end
