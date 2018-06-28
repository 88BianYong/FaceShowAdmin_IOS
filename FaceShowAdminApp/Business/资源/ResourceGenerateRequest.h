//
//  ResourceGenerateRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface ResourceGenerateRequestItem_data:JSONModel
@property (nonatomic, strong) NSString *resid;
@end

@interface ResourceGenerateRequestItem:HttpBaseRequestItem
@property (nonatomic, strong) ResourceGenerateRequestItem_data<Optional> *data;
@end

@interface ResourceGenerateRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *key;
@property (nonatomic, strong) NSString<Optional> *dtype;
@property (nonatomic, strong) NSString<Optional> *callback;
@property (nonatomic, strong) NSString<Optional> *domain;
@property (nonatomic, strong) NSString<Optional> *filename;
@property (nonatomic, strong) NSString<Optional> *filesize;
@property (nonatomic, strong) NSString<Optional> *ext;
@property (nonatomic, strong) NSString<Optional> *reserve;
@property (nonatomic, strong) NSString<Optional> *isexternalUrl;
@end
