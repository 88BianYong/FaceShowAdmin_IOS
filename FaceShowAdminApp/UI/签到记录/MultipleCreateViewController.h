//
//  MultipleCreateViewController.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScrollBaseViewController.h"

@interface MultipleCreateViewController : ScrollBaseViewController
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, strong) void (^comleteBlock)(void);
@end


