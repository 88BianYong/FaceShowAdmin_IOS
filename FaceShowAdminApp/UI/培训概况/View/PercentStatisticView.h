//
//  PercentStatisticView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetSummaryRequest.h"

@interface PercentStatisticView : UIView
@property (nonatomic, strong) GetSummaryRequestItem_platformStatisticInfo *data;
@end
