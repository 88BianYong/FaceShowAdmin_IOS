//
//  AppDelegateHelper.m
//  AppDelegateTest
//
//  Created by niuzhaowang on 2016/9/26.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "AppDelegateHelper.h"
#import "YXTestViewController.h"
#import "LoginViewController.h"
#import "ClassMomentViewController.h"
#import "TaskViewController.h"
#import "MainPageViewController.h"
#import "MineViewController.h"
#import "FSTabBarController.h"
#import "YXDrawerViewController.h"
#import "ClassSelectionViewController.h"
#import "IMUserInterface.h"
#import "IMTopic.h"
#import "ChatListViewController.h"
#import "UserPromptsManager.h"
#import "TrainingProfileViewController.h"
#import "MyTrainingProjectViewController.h"

UIKIT_EXTERN BOOL testFrameworkOn;

@interface AppDelegateHelper ()
@property (nonatomic, strong) UIWindow *window;
@end

@implementation AppDelegateHelper

- (instancetype)initWithWindow:(UIWindow *)window {
    if (self = [super init]) {
        self.window = window;
    }
    return self;
}

- (UIViewController *)rootViewController{
    if (testFrameworkOn) {
        return [self testViewController];
    }else if (![UserManager sharedInstance].loginStatus) {
        return [self loginViewController];
    }else if (![UserManager sharedInstance].userModel.currentClass) {
        GetUserRolesRequestItem_data *data = [UserManager sharedInstance].userModel.roleRequestItem.data;
        if ([data roleExists:UserRole_Teacher]||[data roleExists:UserRole_UnknownTeacher]) {
            return [self classSelectionViewController];
        }
        return [self mainViewController];
    }else {
        return [self mainViewController];
    }
}

- (UIViewController *)testViewController {
    YXTestViewController *vc = [[YXTestViewController alloc]init];
    return [[FSNavigationController alloc]initWithRootViewController:vc];
}

- (UIViewController *)loginViewController {
    LoginViewController *vc = [[LoginViewController alloc] init];
    return [[FSNavigationController alloc] initWithRootViewController:vc];
}

- (UIViewController *)classSelectionViewController {
    ClassSelectionViewController *vc = [[ClassSelectionViewController alloc] init];
    return [[FSNavigationController alloc] initWithRootViewController:vc];
}

- (UIViewController *)mainViewController {
    GetUserRolesRequestItem_data *data = [UserManager sharedInstance].userModel.roleRequestItem.data;
    if (![data roleExists:UserRole_Teacher]&&![data roleExists:UserRole_UnknownTeacher]) {
        UIViewController *paneVC = nil;
        if ([data roleExists:UserRole_PlatformAdmin]||[data roleExists:UserRole_AreaAdmin]) {
            TrainingProfileViewController *vc = [[TrainingProfileViewController alloc]init];
            FSNavigationController *profileNavi = [[FSNavigationController alloc] initWithRootViewController:vc];
            paneVC = profileNavi;
        }else if ([data roleExists:UserRole_ProjectAdmin]||[data roleExists:UserRole_ProjectSteward]) {
            MyTrainingProjectViewController *vc = [[MyTrainingProjectViewController alloc]init];
            FSNavigationController *projectNavi = [[FSNavigationController alloc] initWithRootViewController:vc];
            paneVC = projectNavi;
        }
        MineViewController *mineVC = [[MineViewController alloc]init];
        YXDrawerViewController *drawerVC = [[YXDrawerViewController alloc]init];
        drawerVC.paneViewController = paneVC;
        drawerVC.drawerViewController = mineVC;
        drawerVC.drawerWidth = 305*kPhoneWidthRatio;
        return drawerVC;
    }
    FSTabBarController *tabBarController = [[FSTabBarController alloc] init];
    UIViewController *mainVC = [[MainPageViewController alloc]init];
    mainVC.title = @"首页";
    [self configTabbarItem:mainVC.tabBarItem image:@"首页icon正常态" selectedImage:@"首页icon点击态"];
    FSNavigationController *mainNavi = [[FSNavigationController alloc] initWithRootViewController:mainVC];
    
    UIViewController *taskVC = [[TaskViewController alloc]init];
    taskVC.title = @"任务";
    [self configTabbarItem:taskVC.tabBarItem image:@"任务icon正常态" selectedImage:@"任务icon点击态"];
    FSNavigationController *taskNavi = [[FSNavigationController alloc] initWithRootViewController:taskVC];
    
    UIViewController *classVC = [[ClassMomentViewController alloc]init];
    classVC.title = @"班级圈";
    [self configTabbarItem:classVC.tabBarItem image:@"班级圈icon正常态" selectedImage:@"班级圈icon点击态"];
    FSNavigationController *classNavi = [[FSNavigationController alloc] initWithRootViewController:classVC];
    
    ChatListViewController *chatVC = [[ChatListViewController alloc]init];
    chatVC.title = @"聊聊";
    [self configTabbarItem:chatVC.tabBarItem image:@"聊天icon正常态" selectedImage:@"聊天icon点击态"];
    FSNavigationController *chatNavi = [[FSNavigationController alloc] initWithRootViewController:chatVC];
    
    tabBarController.viewControllers = @[mainNavi, taskNavi, classNavi, chatNavi];
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    YXDrawerViewController *drawerVC = [[YXDrawerViewController alloc]init];
    drawerVC.paneViewController = tabBarController;
    drawerVC.drawerViewController = mineVC;
    drawerVC.drawerWidth = 305*kPhoneWidthRatio;
    
    UIView *momentNewView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 5 / 8 + 2, 6, 9, 9)];
    momentNewView.layer.cornerRadius = 4.5f;
    momentNewView.backgroundColor = [UIColor colorWithHexString:@"ff0000"];
    momentNewView.hidden = YES;
    [tabBarController.tabBar addSubview:momentNewView];
    [tabBarController.tabBar bringSubviewToFront:momentNewView];
    [UserPromptsManager sharedInstance].momentNewView = momentNewView;
    
    UIView *unreadView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 7 / 8 + 2, 6, 9, 9)];
    unreadView.layer.cornerRadius = 4.5f;
    unreadView.backgroundColor = [UIColor colorWithHexString:@"ff0000"];
    unreadView.hidden = YES;
    [tabBarController.tabBar addSubview:unreadView];
    [tabBarController.tabBar bringSubviewToFront:unreadView];
    chatVC.unreadPromptView = unreadView;
    
    return drawerVC;
}

- (void)configTabbarItem:(UITabBarItem *)tabBarItem image:(NSString *)image selectedImage:(NSString *)selectedImage {
    tabBarItem.image = [UIImage imageNamed:image];
    tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:@"a1a8b2"],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHexString:@"0068bd"]} forState:UIControlStateSelected];
}

#pragma mark -
- (void)handleLoginSuccess {
    [self.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    self.window.rootViewController.view.hidden = YES;
    self.window.rootViewController = [self rootViewController];
}

- (void)handleLogoutSuccess {
    [self.window.rootViewController presentViewController:[self loginViewController] animated:YES completion:nil];
}

- (void)handleClassChange {
    [self.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    self.window.rootViewController.view.hidden = YES;
    self.window.rootViewController = [self rootViewController];
}

- (void)handleRemoveFromOneClass:(IMTopic *)topic {
    NSArray *topicsArray = [IMUserInterface findAllTopics];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.window nyx_showToast:[NSString stringWithFormat:@"您管理的班级有调整"] duration:2];
    });
    if (topicsArray.count == 0) {
        [UserManager sharedInstance].loginStatus = NO;
        return;
    }
    if ([[self.window.rootViewController nyx_visibleViewController] isKindOfClass:[ClassSelectionViewController class]]) {
        ClassSelectionViewController *vc = (ClassSelectionViewController *)[self.window.rootViewController nyx_visibleViewController];
        [vc refreshClasses];
        return;
    }
    
    BOOL hasGroup = NO;
    for (IMTopic *topic in topicsArray) {
        if (topic.type == TopicType_Group) {
            hasGroup = YES;
            break;
        }
    }
    if (hasGroup) {
        [UserManager sharedInstance].userModel.currentClass = nil;
        ClassSelectionViewController *selectionVC = [[ClassSelectionViewController alloc] init];
        FSNavigationController *navi = [[FSNavigationController alloc] initWithRootViewController:selectionVC];
        [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
    }else {
        [UserManager sharedInstance].loginStatus = NO;
    }
}

- (UIViewController *)lastPresentedViewController {
    UIViewController *vc = self.window.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}
@end
