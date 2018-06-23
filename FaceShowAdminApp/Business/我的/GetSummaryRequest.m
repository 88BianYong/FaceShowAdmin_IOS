//
//  GetSummaryRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetSummaryRequest.h"

@implementation GetSummaryRequestItem_projectSatisfiedTop_project
@end
@implementation GetSummaryRequestItem_projectSatisfiedTop
@end
@implementation GetSummaryRequestItem_onGoingprojectList
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"projectID"}];
}
@end
@implementation GetSummaryRequestItem_projectStatisticInfo
@end
@implementation GetSummaryRequestItem_platformStatisticInfo
@end
@implementation GetSummaryRequestItem_data
@end
@implementation GetSummaryRequestItem
@end

@implementation GetSummaryRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.platform.getSummary";
    }
    return self;
}
@end
