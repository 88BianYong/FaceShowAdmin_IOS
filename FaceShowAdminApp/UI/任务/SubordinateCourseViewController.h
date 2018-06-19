//
//  SubordinateCourseViewController.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface SubordinateCourseViewController : BaseViewController
@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, copy) void(^chooseSubordinateCoursBlock)(NSString *courseId, NSString *courseName);
@end
