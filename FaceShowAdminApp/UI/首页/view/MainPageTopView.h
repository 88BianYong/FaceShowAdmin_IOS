//
//  MainPageTopView.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClazsGetClazsRequest.h"
@interface MainPageTopView : UIView
@property (nonatomic, strong) ClazsGetClazsRequestItem_Data_ProjectInfo *projectInfo;
@property (nonatomic, strong) ClazsGetClazsRequestItem_Data_ClazsInfo *clazsInfo;
@property (nonatomic, strong) ClazsGetClazsRequestItem_Data_ClazsStatisticView *clazsStatistic;
@end
