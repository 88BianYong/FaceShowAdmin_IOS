//
//  SignInDetailHeaderView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInListRequest.h"

@interface SignInDetailHeaderView : UIView
@property (nonatomic, strong) SignInListRequestItem_signIns *data;
@property (nonatomic, strong) void(^qrBlock)(void);
@end
