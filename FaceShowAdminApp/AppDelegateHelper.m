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
#import "ProjectListViewController.h"
#import "ApnsChatViewController.h"

UIKIT_EXTERN BOOL testFrameworkOn;

@interface AppDelegateHelper ()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) CGFloat notificationViewHeight;
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
    }else if (![UserManager sharedInstance].userModel.currentClass&&[UserManager sharedInstance].mainPage==MainPage_ClassDetail) {
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
    if ([UserManager sharedInstance].mainPage == MainPage_TrainingProfile) {
        TrainingProfileViewController *vc = [[TrainingProfileViewController alloc]init];
        FSNavigationController *profileNavi = [[FSNavigationController alloc] initWithRootViewController:vc];
        MineViewController *mineVC = [[MineViewController alloc]init];
        YXDrawerViewController *drawerVC = [[YXDrawerViewController alloc]init];
        drawerVC.paneViewController = profileNavi;
        drawerVC.drawerViewController = mineVC;
        drawerVC.drawerWidth = 305*kPhoneWidthRatio;
        return drawerVC;
    }
    if ([UserManager sharedInstance].mainPage == MainPage_MyProject) {
        MyTrainingProjectViewController *vc = [[MyTrainingProjectViewController alloc]init];
        FSNavigationController *projectNavi = [[FSNavigationController alloc] initWithRootViewController:vc];
        MineViewController *mineVC = [[MineViewController alloc]init];
        YXDrawerViewController *drawerVC = [[YXDrawerViewController alloc]init];
        drawerVC.paneViewController = projectNavi;
        drawerVC.drawerViewController = mineVC;
        drawerVC.drawerWidth = 305*kPhoneWidthRatio;
        return drawerVC;
    }
    if ([UserManager sharedInstance].mainPage == MainPage_ProjectList) {
        ProjectListViewController *vc = [[ProjectListViewController alloc]init];
        FSNavigationController *projectNavi = [[FSNavigationController alloc] initWithRootViewController:vc];
        MineViewController *mineVC = [[MineViewController alloc]init];
        YXDrawerViewController *drawerVC = [[YXDrawerViewController alloc]init];
        drawerVC.paneViewController = projectNavi;
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

- (void)handleShowTrainingProfile {
    [self.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    self.window.rootViewController.view.hidden = YES;
    self.window.rootViewController = [self rootViewController];
}

- (void)handleShowMyProject {
    [self.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    self.window.rootViewController.view.hidden = YES;
    self.window.rootViewController = [self rootViewController];
}

- (void)handleShowProjectList {
    [self.window.rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    self.window.rootViewController.view.hidden = YES;
    self.window.rootViewController = [self rootViewController];
}

- (void)handleOpenUrl:(NSURL *)url {

}

#pragma mark - Apns
- (void)handleApnsDataOnForeground:(YXApnsContentModel *)apns {
//    [self showNotificationView:apns];
}

- (void)showNotificationView:(YXApnsContentModel *)apns {
    UIView *rootView = [UIApplication sharedApplication].keyWindow;

    self.notificationViewHeight = 0;
    CGFloat width = rootView.frame.size.width;
    CGFloat textWidth = width - 30 - 4;

    UILabel *alertTitle = [[UILabel alloc] init];
    alertTitle.text = apns.content;
    alertTitle.textColor = [UIColor whiteColor];
    alertTitle.font = [UIFont systemFontOfSize:16];
    alertTitle.numberOfLines = 0;
    alertTitle.textAlignment = NSTextAlignmentCenter;
    CGSize titleSize = [apns.content boundingRectWithSize:CGSizeMake(textWidth , MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:alertTitle.font} context:nil].size;
    self.notificationViewHeight = titleSize.height + 50;

    UIView *notificationView = [[UIView alloc] init];
    notificationView.frame = CGRectMake(0, -self.notificationViewHeight, CGRectGetWidth(rootView.frame), self.notificationViewHeight);
    notificationView.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:notificationView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = notificationView.bounds;
    maskLayer.path = maskPath.CGPath;
    notificationView.layer.mask = maskLayer;
    [rootView addSubview:notificationView];

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(2, 2, width - 4, self.notificationViewHeight - 4)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    UIBezierPath *bgMaskPath = [UIBezierPath bezierPathWithRoundedRect:bgView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];    CAShapeLayer *bgMaskLayer = [CAShapeLayer layer];
    bgMaskLayer.frame = bgView.bounds;
    bgMaskLayer.path = bgMaskPath.CGPath;
    bgView.layer.mask = bgMaskLayer;
    bgView.clipsToBounds = YES;
    [notificationView addSubview:bgView];

    [notificationView addSubview:alertTitle];
    alertTitle.frame = CGRectMake(15, 25, textWidth, titleSize.height);

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [notificationView addGestureRecognizer:tapRecognizer];
    WEAK_SELF;
    [[tapRecognizer rac_gestureSignal] subscribeNext:^(UIPanGestureRecognizer *paramSender) {
        STRONG_SELF;
        [self hideNotificationView:notificationView];
        [self handleApnsData:apns];
    }];

    // auto hide after 2 seconds
    [UIView animateWithDuration:0.3 animations:^{
        notificationView.frame = CGRectMake(0, 0, CGRectGetWidth(rootView.frame), self.notificationViewHeight);
    } completion:^(BOOL finished) {
        STRONG_SELF;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideNotificationView:notificationView];
        });
    }];
}

- (void)hideNotificationView:(UIView *)view {
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(0, -self.notificationViewHeight, CGRectGetWidth(view.frame), self.notificationViewHeight);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void)handleApnsData:(YXApnsContentModel *)apns {
    NSInteger type = apns.type.integerValue;
    if (type == 221001) {
        [self goChatWithData:apns];
    }
}

- (void)goChatWithData:(YXApnsContentModel *)data{
    NSArray *topics =  [IMUserInterface findAllTopics];
    IMTopic *currentTopic;
    for (IMTopic *topic in topics) {
        if (topic.topicID == data.objectId.integerValue) {
            currentTopic = topic;
            break;
        }
    }
    if (!currentTopic) {
        currentTopic = [[IMTopic alloc]init];
        currentTopic.topicID = atoll([data.objectId UTF8String]);
    }
    ApnsChatViewController *chat = [[ApnsChatViewController alloc]init];
    chat.topic = currentTopic;
    FSNavigationController *navi = [[FSNavigationController alloc] initWithRootViewController:chat];
    [[self lastPresentedViewController] presentViewController:navi animated:YES completion:nil];
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
