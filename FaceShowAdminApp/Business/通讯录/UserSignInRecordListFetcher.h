//
//  UserSignInRecordListFetcher.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface UserSignInRecordListFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *userId;
@end
