//
//  ScoreRankingFetcher.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface ScoreRankingFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *clazzId;
@property (nonatomic, strong) void(^finishBlock) (NSString *avargeValue);
@end
