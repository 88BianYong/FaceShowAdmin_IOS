//
//  QRCodeSignInViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "SignInListRequest.h"

@interface QRCodeSignInViewController : BaseViewController
@property (nonatomic, strong) SignInListRequestItem_signIns *data;
@property (nonatomic, strong) void(^backBlock)(void);
@end
