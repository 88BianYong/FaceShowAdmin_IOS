//
//  SignInDetailViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "SignInListRequest.h"

@interface SignInDetailViewController : BaseViewController
@property (nonatomic, strong) SignInListRequestItem_signIns *data;
@property (nonatomic, strong) void(^deleteBlock)(void);
@end
