//
//  EditQuestionViewController.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "CreateComplexRequest.h"
#import "CreateQuestionGroupItem.h"
@interface EditQuestionViewController : BaseViewController
@property (nonatomic, assign) CreateComplexType createType;
@property (nonatomic, strong) CreateQuestionGroupItem_Question *question;
@property (nonatomic, copy) void(^editQuestionBlock)(CreateQuestionGroupItem_Question *item);
@property (nonatomic, assign) NSInteger serialNumber;
@end
