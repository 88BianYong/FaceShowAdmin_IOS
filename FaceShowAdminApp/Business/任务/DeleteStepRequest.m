//
//  DeleteStepRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "DeleteStepRequest.h"

@implementation DeleteStepRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.deleteStep";
    }
    return self;
}
@end
