//
//  UserSignInListFetcher.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface UserSignInListFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) void(^noMoreBlock) (void);
@end
