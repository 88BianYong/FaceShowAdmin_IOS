//
//  PasswordSubmitView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordSubmitView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) void(^actionBlock) (void);
@property (nonatomic, assign) BOOL isActive;
@end
