//
//  CourseResourceFetcher.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface CourseResourceFetcher : PagedListFetcherBase
@property (nonatomic, strong) NSString<Optional> *courseId;
@end
