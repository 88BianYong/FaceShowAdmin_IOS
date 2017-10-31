//
//  SignInDateTimeView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInDateTimeView : UIView
@property (nonatomic, strong) void(^selectionBlock)(void);

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@end
