//
//  UpdateTextInfoViewController.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface UpdateTextInfoViewController : BaseViewController
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) void(^updateTextInfoSucceedBlock) (void);
@end
