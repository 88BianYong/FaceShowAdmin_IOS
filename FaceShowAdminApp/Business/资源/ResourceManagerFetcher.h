//
//  ResourceManagerFetcher.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "ResourceManagerRequest.h"
@interface ResourceManagerFetcher : PagedListFetcherBase
@property (nonatomic, copy) NSString<Optional> *clazsId;
@end
