//
//  CreateQuestionGroupItem.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateQuestionGroupItem.h"
@implementation CreateQuestionGroupItem_Question_VoteInfo_VoteItem @end
@implementation CreateQuestionGroupItem_Question_VoteInfo @end
@implementation CreateQuestionGroupItem_Question
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"questionId",@"description":@"desc"}];
}
@end
@implementation CreateQuestionGroupItem
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"desc"}];
}
@end
