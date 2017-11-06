//
//  CourseListItemCell.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCourseListRequest.h"

@interface CourseListItemCell : UITableViewCell
@property (nonatomic, strong) GetCourseListRequestItem_coursesList *item;
@property (nonatomic, assign) BOOL showLineFromLeft;
@end
