//
//  AddMemberViewController.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScrollBaseViewController.h"

@interface AddMemberViewController : ScrollBaseViewController
@property (nonatomic, copy) void (^saveSucceedBlock)(void);
@end
