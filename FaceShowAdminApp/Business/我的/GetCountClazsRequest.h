//
//  GetCountClazsRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetCountClazsRequestItem_data:JSONModel
@property (nonatomic, strong) NSString<Optional> *taskFinishedRate;
@property (nonatomic, strong) NSString<Optional> *studentAvgScore;
@property (nonatomic, strong) NSString<Optional> *studentReportRate;
@property (nonatomic, strong) NSString<Optional> *courseNum;
@property (nonatomic, strong) NSString<Optional> *homeworkNum;
@property (nonatomic, strong) NSString<Optional> *signedNum;
@property (nonatomic, strong) NSString<Optional> *resourceNum;
@property (nonatomic, strong) NSString<Optional> *momentNum;
@property (nonatomic, strong) NSString<Optional> *taskNum;
@property (nonatomic, strong) NSString<Optional> *studentNum;
@property (nonatomic, strong) NSString<Optional> *masterNum;
@property (nonatomic, strong) NSString<Optional> *evaluateNum;
@property (nonatomic, strong) NSString<Optional> *appUsedNum;
@property (nonatomic, strong) NSString<Optional> *projectSatisfiedPercent;
@end

@interface GetCountClazsRequestItem:HttpBaseRequestItem
@property (nonatomic, strong) GetCountClazsRequestItem_data<Optional> *data;
@end

@interface GetCountClazsRequest : YXGetRequest
@property (nonatomic, strong) NSString *clazsId;
@end
