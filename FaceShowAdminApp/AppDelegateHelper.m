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
#import "CourseListViewController.h"
#import "TaskViewController.h"
#import "MainPageViewController.h"
#import "MineViewController.h"
#import "FSTabBarController.h"
#import "YXDrawerViewController.h"
#import "ClassSelectionViewController.h"

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
    if ([ConfigManager sharedInstance].testFrameworkOn.boolValue) {
        return [self testViewController];
    }else if (![UserManager sharedInstance].loginStatus) {
        return [self loginViewController];
    }else if (![UserManager sharedInstance].userModel.currentClass) {
        return [self classSelectionViewController];
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
    FSTabBarController *tabBarController = [[FSTabBarController alloc] init];
    UIViewController *mainVC = [[MainPageViewController alloc]init];
    mainVC.title = @"首页";
    [self configTabbarItem:mainVC.tabBarItem image:@"首页icon" selectedImage:@"首页icon选择"];
    FSNavigationController *mainNavi = [[FSNavigationController alloc] initWithRootViewController:mainVC];
    
    UIViewController *courseVC = [[CourseListViewController alloc]initWithClazsId:[UserManager sharedInstance].userModel.currentClass.clazsId];
    courseVC.title = @"课程";
    [self configTabbarItem:courseVC.tabBarItem image:@"通知icon" selectedImage:@"通知icon选择"];
    FSNavigationController *courseNavi = [[FSNavigationController alloc] initWithRootViewController:courseVC];
    
    UIViewController *taskVC = [[TaskViewController alloc]init];
    taskVC.title = @"任务";
    [self configTabbarItem:taskVC.tabBarItem image:@"我的icon" selectedImage:@"我的icon选择"];
    FSNavigationController *taskNavi = [[FSNavigationController alloc] initWithRootViewController:taskVC];
    
    UIViewController *classVC = [[ClassMomentViewController alloc]init];
    classVC.title = @"班级圈";
    [self configTabbarItem:classVC.tabBarItem image:@"朋友圈icon" selectedImage:@"朋友圈icon选择"];
    FSNavigationController *classNavi = [[FSNavigationController alloc] initWithRootViewController:classVC];
    
    tabBarController.viewControllers = @[mainNavi, courseNavi, taskNavi, classNavi];
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    YXDrawerViewController *drawerVC = [[YXDrawerViewController alloc]init];
    drawerVC.paneViewController = tabBarController;
    drawerVC.drawerViewController = mineVC;
    drawerVC.drawerWidth = 305*kPhoneWidthRatio;
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

@end
