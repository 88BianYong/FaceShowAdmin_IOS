//
//  QuestionnaireHeaderView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionRequestItem.h"

@interface QuestionnaireHeaderView : UIView
@property (nonatomic, strong) QuestionRequestItem_data *data;
@property (nonatomic, strong) void(^detailBlock)(void);
@end
