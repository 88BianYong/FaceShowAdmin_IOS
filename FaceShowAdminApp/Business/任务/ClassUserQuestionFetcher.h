//
//  ClassUserQuestionFetcher.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface ClassUserQuestionFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) void(^noMoreBlock) (void);
@end
