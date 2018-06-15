//
//  MainPageScrollView.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MainPagePushType){
    MainPagePushType_Contacts = 1,//通讯录
    MainPagePushType_Notice = 2,//通知管理
    MainPagePushType_Check = 3,//签到记录
    MainPagePushType_Schedule = 4,//日程管理
    MainPagePushType_Resources = 5,//资源管理
    MainPagePushType_Course = 6,//课程
    MainPagePushType_LearningSituation = 7//班级学情
};
@interface MainPageScrollView : UIScrollView
@property (nonatomic, strong) void (^actionBlock)(MainPagePushType type);

@end
