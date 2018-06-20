//
//  TaskListCell.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetAllTasksRequest.h"

@interface TaskListCell : UITableViewCell
@property (nonatomic, strong) GetAllTasksRequestItem_task *data;
@property (nonatomic, assign) BOOL lineHidden;
@end
