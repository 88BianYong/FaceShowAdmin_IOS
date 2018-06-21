//
//  ScoreEditViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
@class GetClazsScoreConfigRequestItem_data;
@class GetClazsScoreConfigRequestItem_configItem;

@interface ScoreEditViewController : BaseViewController
@property (nonatomic, strong) GetClazsScoreConfigRequestItem_data *data;
@property (nonatomic, strong) GetClazsScoreConfigRequestItem_configItem *currentItem;
@property (nonatomic, strong) void(^finishBlock) (void);
@end
