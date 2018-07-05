//
//  ChooseTemplateViewController.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "CreateQuestionGroupItem.h"
@interface ChooseTemplateViewController : BaseViewController
@property (nonatomic, copy) void(^loadTemplateBlock)(CreateQuestionGroupItem *itemData);
@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, copy) NSString *interactType;
@end
