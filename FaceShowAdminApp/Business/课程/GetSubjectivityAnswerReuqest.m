//
//  GetSubjectivityAnswerReuqest.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "GetSubjectivityAnswerReuqest.h"

@implementation GetsubjectivityAnswer_Element
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}
@end

@implementation GetSubjectivityAnswerItem
@end

@implementation GetSubjectivityAnswerReuqest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.getSubjectivityAnswer";
    }
    return self;
}
@end
