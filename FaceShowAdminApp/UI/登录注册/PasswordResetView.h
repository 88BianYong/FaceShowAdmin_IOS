//
//  PasswordResetView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInputView.h"

@interface PasswordResetView : UIView
@property (nonatomic, strong) LoginInputView *inputView;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong) void(^textChangeBlock) (void);
@end
