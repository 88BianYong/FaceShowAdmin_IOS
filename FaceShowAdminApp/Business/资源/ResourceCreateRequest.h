//
//  ResourceCreateRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface ResourceCreateRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSString<Optional> *resid;
@end
@interface ResourceCreateRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *filename;
@property (nonatomic, strong) NSString<Optional> *createtime;
@property (nonatomic, strong) NSString<Optional> *reserve;
@property (nonatomic, strong) NSString<Optional> *from_flow;
@end
