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
NSString * const kGeTuiAppKey = @"cCOvIl20LI6qywnwYagBH4";
NSString * const kGeTuiAppSecret = @"flNeBaRe8i8fMaup3hNgN4";
#else
NSString * const kGeTuiAppID = @"UNWi3b7To375ryWuXeVcx1";
NSString * const kGeTuiAppKey = @"WpO3Hw4dW162RqHPPoQuO9";
NSString * const kGeTuiAppSecret = @"irRRDZLCXz7FXLYis7tOe9";
#endif

#else

#ifdef DEBUG
NSString * const kGeTuiAppID = @"qZWK01tMVqA9qfpPmQvB14";
NSString * const kGeTuiAppKey = @"4bgAF1Ou4383OerMy9Rwz9";
NSString * const kGeTuiAppSecret = @"TNXj85ncrE7CYwGYfY2M8";
#else
NSString * const kGeTuiAppID = @"NhgAL7Zmxw796NvTvzo6s7";
NSString * const kGeTuiAppKey = @"tHjRRmX6Kh7o2BGl49cp01";
NSString * const kGeTuiAppSecret = @"I0s4du0eZh9rqmeI8dgmi3";
#endif

#endif


@implementation GeTuiConfig

@end
