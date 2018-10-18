//
//  SignInLocationView.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/5/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInLocationView : UIView
@property (nonatomic, strong) void(^selectionBlock)(void);

@property (nonatomic, strong) NSString *locationStr;
@end
