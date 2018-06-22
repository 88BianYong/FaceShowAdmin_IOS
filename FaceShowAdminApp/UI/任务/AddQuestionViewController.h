//
//  AddQuestionViewController.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/21.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "CreateComplexRequest.h"
#import "CreateQuestionGroupItem.h"
@interface AddQuestionViewController : BaseViewController
@property (nonatomic, assign) CreateComplexType createType;
@property (nonatomic, copy) void(^addQuestionBlock)(CreateQuestionGroupItem_Question *item);
@property (nonatomic, assign) NSInteger serialNumber;
@end
