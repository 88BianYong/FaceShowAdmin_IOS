//
//  PageNameMappingTable.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PageNameMappingTable.h"

static NSDictionary *mappingDict = nil;

@implementation PageNameMappingTable
+ (NSString *)pageNameForViewControllerName:(NSString *)vcName {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        mappingDict = @{@"LoginViewController":@"登录",
                        @"ClassSelectionViewController":@"切换班级",
                        @"MineViewController":@"左侧抽屉",
                        @"MainPageViewController":@"首页",
                        @"MainPageDetailViewController":@"班级详情",
                        @"NoticeListViewController":@"通知管理",
                        @"NoticeSaveViewController":@"发布通知",
                        @"NoticeDetailViewController":@"通知详情",
                        @"SignInListViewController":@"班级签到记录",
                        @"ContactsViewController":@"通讯录",
                        @"ContactsDetailViewController":@"学员详情",
                        @"UserSignInListViewController":@"个人签到记录",
                        @"AddMemberViewController":@"添加成员",
                        @"TaskViewController":@"班级任务",
                        @"ClassMomentViewController":@"班级圈",
                        @"ScheduleDetailViewController":@"日程管理",
                        @"ScheduleCreateViewController":@"发布日程",
                        @"CourseListViewController":@"课程",
                        @"CourseDetailViewController":@"课程详情",
                        @"CourseInfoViewController":@"课程简介",
                        @"CourseCommentViewController":@"讨论",
                        @"SignInDetailViewController":@"签到详情",
                        @"QRCodeSignInViewController":@"签到二维码",
                        @"CreateSignInViewController":@"新建签到",
                        @"MyInfoViewController":@"我的资料",
                        @"ResourceManagerViewController":@"资源管理",
                        @"ResourceDetailViewController":@"资源详情",
                        @"ResourceUploadViewController":@"上传资源",
                        @"SubjectivityAnswerViewController":@"问卷主观题答案详情"
                        };
    });
    return [mappingDict valueForKey:vcName];
}
@end
