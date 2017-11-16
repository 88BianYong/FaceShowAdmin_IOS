//
//  ResourceUploadViewController.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface ResourceUploadViewController : BaseViewController
@property (nonatomic, copy) void(^uploadSucceedBlock)(void);
@end
