//
//  GeTuiConfig.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/4/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GeTuiConfig.h"

#ifdef HuBeiApp

#ifdef DEBUG
NSString * const kGeTuiAppID = @"YkAxO4lGM19YgxLgEgpkl6";
NSString * const kGeTuiAppKey = @"flNeBaRe8i8fMaup3hNgN4";
NSString * const kGeTuiAppSecret = @"cCOvIl20LI6qywnwYagBH4";
#else
NSString * const kGeTuiAppID = @"UNWi3b7To375ryWuXeVcx1";
NSString * const kGeTuiAppKey = @"irRRDZLCXz7FXLYis7tOe9";
NSString * const kGeTuiAppSecret = @"WpO3Hw4dW162RqHPPoQuO9";
#endif

#else

#ifdef DEBUG
NSString * const kGeTuiAppID = @"qZWK01tMVqA9qfpPmQvB14";
NSString * const kGeTuiAppKey = @"TNXj85ncrE7CYwGYfY2M8";
NSString * const kGeTuiAppSecret = @"4bgAF1Ou4383OerMy9Rwz9";
#else
NSString * const kGeTuiAppID = @"NhgAL7Zmxw796NvTvzo6s7";
NSString * const kGeTuiAppKey = @"I0s4du0eZh9rqmeI8dgmi3";
NSString * const kGeTuiAppSecret = @"tHjRRmX6Kh7o2BGl49cp01";
#endif

#endif


@implementation GeTuiConfig

@end
