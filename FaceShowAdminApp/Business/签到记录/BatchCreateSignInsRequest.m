//
//  BatchCreateSignInsRequest.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BatchCreateSignInsRequest.h"

@implementation BatchCreateSignInsRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.batchCreateSignIns";
    }
    return self;
}
@end
