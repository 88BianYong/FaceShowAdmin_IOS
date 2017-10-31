//
//  MainPageDetailViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MainPageDetailViewController.h"
#import "DetailContainerView.h"
#import "MainProjectDetailView.h"
#import "MainClassDetailView.h"
@interface MainPageDetailViewController ()
@property (nonatomic, strong) DetailContainerView *containerView;
@property (nonatomic, strong) MainProjectDetailView *projectView;
@property (nonatomic, strong) MainClassDetailView *classView;
@end

@implementation MainPageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    [self setupUI];
    [self setupLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    self.projectView = [[MainProjectDetailView alloc] initWithFrame:CGRectZero];
    self.classView = [[MainClassDetailView alloc] initWithFrame:CGRectZero];
    self.containerView = [[DetailContainerView alloc] initWithFrame:self.view.bounds];
    self.containerView.contentViews = @[self.projectView,self.classView];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    self.projectView.itemData = self.itemData;
    self.classView.itemData = self.itemData;
}
- (void)setupLayout {
}
@end
