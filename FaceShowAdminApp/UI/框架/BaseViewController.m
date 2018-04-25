//
//  BaseViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "YXDrawerController.h"
#import "PageNameMappingTable.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)adjustNaviLeftItem {
    NSArray *array=self.navigationItem.leftBarButtonItems;
    if (isEmpty(array)) {
        return;
    }
    UIBarButtonItem *flexItem = array.firstObject;
    CGFloat x = flexItem.width + 16;
    UIBarButtonItem * buttonItem=array.lastObject;
    CGPoint p = [buttonItem.customView convertPoint:CGPointZero toView:self.view.window];
    UIView *bottomView = buttonItem.customView.superview.superview;
    CGRect rect = bottomView.frame;
    rect.origin.x -= p.x-x;
    for (NSLayoutConstraint *constraint in bottomView.superview.constraints) {
        if (constraint.firstItem == bottomView) {
            [bottomView.superview removeConstraint:constraint];
        }
    }
    [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(rect.origin.x);
        make.top.mas_equalTo(rect.origin.y);
        make.size.mas_equalTo(rect.size);
    }];
}

- (void)adjustNaviRightItem {
    NSArray *array=self.navigationItem.rightBarButtonItems;
    if (isEmpty(array)) {
        return;
    }
    UIBarButtonItem *flexItem = array.firstObject;
    CGFloat x = flexItem.width + 16;
    UIBarButtonItem * buttonItem=array.lastObject;
    CGPoint p = [buttonItem.customView convertPoint:CGPointZero toView:self.view.window];
    UIView *bottomView = buttonItem.customView.superview.superview;
    CGRect rect = bottomView.frame;
    rect.origin.x += SCREEN_WIDTH-p.x-buttonItem.customView.width-x;
    for (NSLayoutConstraint *constraint in bottomView.superview.constraints) {
        if (constraint.firstItem == bottomView) {
            [bottomView.superview removeConstraint:constraint];
        }
    }
    [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(rect.origin.x);
        make.top.mas_equalTo(rect.origin.y);
        make.size.mas_equalTo(rect.size);
    }];
}

//#warning 先注释掉，强行改变系统行为有约束冲突，暂时没找到解决方案
//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    if ([UIDevice currentDevice].systemVersion >= 11) {
//        [self adjustNaviLeftItem];
//        [self adjustNaviRightItem];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSArray *vcArray = self.navigationController.viewControllers;
    if (!isEmpty(vcArray)) {
        if (vcArray[0] != self) {
            WEAK_SELF
            [self nyx_setupLeftWithImageName:@"返回页面按钮正常态" highlightImageName:@"返回页面按钮点击态" action:^{
                STRONG_SELF
                [self backAction];
            }];
        }
    }
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    NSString *vcName = NSStringFromClass([self class]);
    NSString *pageName = [PageNameMappingTable pageNameForViewControllerName:vcName];
    if (pageName) {
        [TalkingData trackPageEnd:pageName];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSString *vcName = NSStringFromClass([self class]);
    NSString *pageName = [PageNameMappingTable pageNameForViewControllerName:vcName];
    if (pageName) {
        [TalkingData trackPageBegin:pageName];
    }
    
}

#pragma mark -
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UINavigationController *)navigationController{
    UINavigationController *navi = [super navigationController];
    if (!navi) {
        YXDrawerViewController *drawerVC = [YXDrawerController drawer];
        if ([drawerVC.paneViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarVC = (UITabBarController *)drawerVC.paneViewController;
            navi = tabBarVC.viewControllers[tabBarVC.selectedIndex];
        }
    }
    return navi;
}

@end
