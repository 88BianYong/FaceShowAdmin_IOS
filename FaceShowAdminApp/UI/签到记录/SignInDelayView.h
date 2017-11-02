//
//  SignInDelayView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInDelayView : UIView
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) void(^confirmBlock)(NSString *result);
@end
