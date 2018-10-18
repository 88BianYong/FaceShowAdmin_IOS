//
//  SignInTypeSelectView.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SignInType_Code = 1,
    SignInType_Location = 2
} SignInType;

@interface SignInTypeSelectView : UIView

@property(nonatomic, assign) SignInType signType;
@property(nonatomic, copy) void(^ChooseSignTypeBlock)(void);
@property(nonatomic, assign) BOOL canSelect;
@end


