//
//  CreateSignInViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScrollBaseViewController.h"

@interface CreateSignInViewController : ScrollBaseViewController
@property (nonatomic, strong) void (^comleteBlock)(void);
@property (nonatomic, copy) NSString *stepId;
@end
