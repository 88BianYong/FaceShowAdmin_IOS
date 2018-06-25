//
//  SignInDateTimeSettingView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInDateTimeSettingView : UIView
@property (nonatomic, assign) UIDatePickerMode mode;
@property (nonatomic, strong) void(^cancelBlock)(void);
@property (nonatomic, strong) void(^confirmBlock)(NSString *result);
@property (nonatomic, strong) NSTimeZone *timeZone;
@end
