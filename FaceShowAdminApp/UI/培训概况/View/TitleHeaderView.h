//
//  TitleHeaderView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) void(^titleButtonBlock)(void);
@end
