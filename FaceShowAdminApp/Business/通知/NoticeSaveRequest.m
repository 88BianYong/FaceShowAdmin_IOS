//
//  NoticeSaveRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeSaveRequest.h"
@implementation NoticeSaveRequestItem

@end
@implementation NoticeSaveRequest
- (instancetype)init {
    if (self = [super init]) {
        self.method = @"notice.save";
    }
    return self;
}
@end
