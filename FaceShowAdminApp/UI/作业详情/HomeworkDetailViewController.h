//
//  HomeworkDetailViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
@class GetHomeworkRequestItem;

@interface HomeworkDetailViewController : BaseViewController
@property(nonatomic, strong) GetHomeworkRequestItem *item;
@end
