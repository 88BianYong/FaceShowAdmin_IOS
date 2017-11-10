//
//  DeleteCommentRequest.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "DeleteCommentRequest.h"

@implementation DeleteCommentRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.deleteUserComment";
    }
    return self;
}
@end
