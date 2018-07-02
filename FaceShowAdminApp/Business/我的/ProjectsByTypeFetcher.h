//
//  ProjectsByTypeFetcher.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/8/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface ProjectsByTypeFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString *projectQueryType;
@property (nonatomic, strong) NSString *projectQueryTypeValue;
@property (nonatomic, strong) NSString *provinceId;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *districtId;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@end
