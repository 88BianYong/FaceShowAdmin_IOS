//
//  TaskChooseContentView.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,SubordinateCourseType) {
    SubordinateCourse_Class,
    SubordinateCourse_Course
};
@interface TaskChooseContentView : UIView
@property (nonatomic, strong) NSString *chooseContentString;
@property (nonatomic, copy) void(^pushSubordinateCourseBlock)(void);
@property (nonatomic, assign) SubordinateCourseType chooseType;
@end
