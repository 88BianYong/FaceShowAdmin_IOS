//
//  StageSubjectManager.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "StageSubjectManager.h"

@implementation Subject
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"subjectID"}];
}
@end

@implementation Stage
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"stageID",@"sub":@"subjects"}];
}
@end

@implementation StageSubjectModel
@end

@implementation StageSubjectManager
+ (StageSubjectManager *)sharedInstance {
    static dispatch_once_t once;
    static StageSubjectManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[StageSubjectManager alloc] init];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"StageSubject" ofType:@"json"];
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        sharedInstance.stageSubjectModel = [[StageSubjectModel alloc]initWithData:data error:nil];
    });
    
    return sharedInstance;
}
@end
