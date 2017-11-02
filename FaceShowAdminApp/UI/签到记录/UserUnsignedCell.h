//
//  UserUnsignedCell.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSignInListRequest.h"

@interface UserUnsignedCell : UITableViewCell
@property (nonatomic, strong) UserSignInListRequestItem_elements *data;
@property (nonatomic, strong) void(^signBlock)(void);
@end
