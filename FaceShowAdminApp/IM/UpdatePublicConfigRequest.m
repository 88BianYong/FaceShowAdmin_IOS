//
//  UpdatePublicConfigRequest.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/9/3.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "UpdatePublicConfigRequest.h"
#import "IMConfig.h"
#import "IMManager.h"

@implementation UpdatePublicConfigRequestItem

@end

@interface UpdatePublicConfigRequest ()
@property (nonatomic, strong) NSString *bizSource;
@property (nonatomic, strong) NSString *imToken;
@property (nonatomic, strong) NSString *imExt;
@end

@implementation UpdatePublicConfigRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = kIMRequestUrlHead;
        self.method = @"topic.updatePublicConfig";
        self.reqId = [IMConfig generateUniqueID];
        self.imToken = [[IMManager sharedInstance]token];
        self.imExt = [IMConfig sceneInfoString];
        self.bizSource = kBizSourse;
    }
    return self;
}
@end
