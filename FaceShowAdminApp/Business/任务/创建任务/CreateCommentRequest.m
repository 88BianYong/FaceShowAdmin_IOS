//
//  CreateCommentRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateCommentRequest.h"

@implementation CreateCommentRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.createComment";
    }
    return self;
}
@end
