//
//  CreateComplexRequest.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateComplexRequest.h"
@implementation CreateComplexRequestItem
@end
@implementation CreateComplexRequest
- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}
- (void)setCreateType:(CreateComplexType)createType {
    if (createType == CreateComplex_Vote) {
        self.method = @"interact.createVote";
    }else if (createType == CreateComplex_Questionnaire) {
        self.method = @"interact.createQuestionnaire";
    }else {
        self.method = @"interact.createEvaluate";
    }
}
@end
