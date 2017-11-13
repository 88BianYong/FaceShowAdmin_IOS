//
//  GetSubjectivityAnswerListFetcher.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "GetSubjectivityAnswerReuqest.h"

@interface GetSubjectivityAnswerListFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *questionId;
@property (nonatomic, strong) void(^finishBlock)(GetSubjectivityAnswerItem *item);
@end
