//
//  MultipleSignDateSelectView.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignDateSelectTypeMode.h"

@interface MultipleSignDateSelectView : UIView
- (instancetype)initWithSelectTitle:(NSString *)title startString:(NSString *)startStr endString:(NSString *)endStr;
@property (nonatomic, assign) SignDateSelectTypeMode type;
@property (nonatomic, readonly ,assign) BOOL buttonEnabled;
@property (nonatomic, readonly ,strong) NSString *canBeSubmitted;
@property (nonatomic, copy) void(^selectDateBlock)(NSInteger index);
@property (nonatomic, copy) void(^deleteBlock)(void);
- (void)setSelectDate:(NSString *)dateStr atRow:(NSInteger)row;
- (NSDictionary *)signTimeDic;
@end
