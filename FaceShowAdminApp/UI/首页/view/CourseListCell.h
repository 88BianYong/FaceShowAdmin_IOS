//
//  CourseListCell.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClazsGetClazsRequest.h"
@interface CourseListCell : UITableViewCell
@property (nonatomic, strong) ClazsGetClazsRequestItem_Data_TodayCourses *item;
@end
