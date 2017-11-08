//
//  UserSignInListCell.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInListRequest.h"

@interface UserSignInListCell : UITableViewCell
@property (nonatomic, strong) SignInListRequestItem_signIns *data;
@property (nonatomic, copy) void (^signInBtnBlock)(void);
@end
