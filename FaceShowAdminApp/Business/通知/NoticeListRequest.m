//
//  NoticeListRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeListRequest.h"
@implementation NoticeListRequestItem_Data_NoticeInfos_Elements
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
@end

@implementation NoticeListRequestItem_Data_NoticeInfos
@end

@implementation NoticeListRequestItem_Data
@end

@implementation NoticeListRequestItem
@end

@implementation NoticeListRequest
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.manage.getNotices";
        
    }
    return self;
}
@end
