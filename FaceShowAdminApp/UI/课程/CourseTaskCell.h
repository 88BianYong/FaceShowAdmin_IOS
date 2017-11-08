//
//  CourseTaskCell.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCourseRequest.h"

@interface CourseTaskCell : UITableViewCell
@property (nonatomic, strong) GetCourseRequestItem_InteractStep *data;
@end
