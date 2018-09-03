//
//  UpdatePublicConfigRequest.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/9/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "TopicData.h"

@interface UpdatePublicConfigRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) TopicData<Optional> *data;
@end

@interface UpdatePublicConfigRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *reqId;
@property (nonatomic, strong) NSString<Optional> *bidId;
@property (nonatomic, strong) NSString<Optional> *topicId;
@property (nonatomic, strong) NSString<Optional> *speak;//禁言：0-非禁言 1-禁言 空-不设置
@end
