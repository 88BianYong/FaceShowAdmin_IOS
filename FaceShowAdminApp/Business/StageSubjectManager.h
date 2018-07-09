//
//  StageSubjectManager.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Subject<NSObject>
@end
@interface Subject:JSONModel
@property (nonatomic, strong) NSString *subjectID;
@property (nonatomic, strong) NSString *name;
@end

@protocol Stage<NSObject>
@end
@interface Stage:JSONModel
@property (nonatomic, strong) NSString *stageID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<Subject, Optional> *subjects;
@end

@interface StageSubjectModel:JSONModel
@property (nonatomic, strong) NSArray<Stage,Optional> *data;
@end

@interface StageSubjectManager : NSObject
+ (StageSubjectManager *)sharedInstance;

@property (nonatomic, strong) StageSubjectModel *stageSubjectModel;
@end
