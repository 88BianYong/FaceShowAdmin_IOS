//
//  GetEvaluateRequest.m
//  FaceShowApp
//
//  Created by ZLL on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "GetEvaluateRequest.h"

@implementation GetEvaluateRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"app.manage.interact.getEvaluate";
    }
    return self;
}
@end
