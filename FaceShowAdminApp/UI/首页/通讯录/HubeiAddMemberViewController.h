//
//  HubeiAddMemberViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScrollBaseViewController.h"

@interface HubeiAddMemberViewController : ScrollBaseViewController
@property (nonatomic, copy) void (^saveSucceedBlock)(void);
@end
