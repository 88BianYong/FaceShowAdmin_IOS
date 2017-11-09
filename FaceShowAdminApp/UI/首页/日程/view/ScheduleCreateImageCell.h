//
//  ScheduleImageCell.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleCreateImageCell : UITableViewCell
@property (nonatomic, strong) UIButton *chooseButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, assign) BOOL isContainImage;
@end
