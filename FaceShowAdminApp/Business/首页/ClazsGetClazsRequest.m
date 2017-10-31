//
//  ClazsGetClazsRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClazsGetClazsRequest.h"
@implementation ClazsGetClazsRequestItem_Data_ClazsStatisticView

@end
@implementation ClazsGetClazsRequestItem_Data_ClazsInfo
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"clazsId", @"description" : @"desc"}];
}
@end

@implementation ClazsGetClazsRequestItem_Data_TodaySignIns
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"signInId"}];
}
@end
@implementation ClazsGetClazsRequestItem_Data_ProjectInfo
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"projectId",@"description":@"desc"}];
}
@end
@implementation ClazsGetClazsRequestItem_Data_TodayCourses_LecturerInfos
@end
@implementation ClazsGetClazsRequestItem_Data_TodayCourses
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"courseId"}];
}
@end
@implementation ClazsGetClazsRequestItem_Data
@end
@implementation ClazsGetClazsRequestItem
@end
@implementation ClazsGetClazsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.manage.clazs.getClazs";
//        self.token = @"ac962d7045d51dbfedfdd35d2b1d97c5";
    }
    return self;
}
@end
