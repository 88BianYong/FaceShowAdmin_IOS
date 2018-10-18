//
//  MultipleSignDateView.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignDateSelectTypeMode.h"
@class MultipleSignDateSelectView;

@interface MultipleSignDateView : UIView

@property (nonatomic, copy) void(^dateSelectBlock)(MultipleSignDateSelectView *selectView,NSInteger row);
- (void)setDefaultStartDate:(NSString *)startTime endDate:(NSString *)endTime;
@property (nonatomic, readonly ,assign) BOOL buttonEnabled;
@property (nonatomic, readonly, assign) NSString *canBeSubmitted;
- (NSString *)signInTimeSetting;
@end
