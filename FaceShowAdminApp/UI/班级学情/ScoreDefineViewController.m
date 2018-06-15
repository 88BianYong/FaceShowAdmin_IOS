//
//  ScoreDefineViewController.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScoreDefineViewController.h"

@interface ScoreDefineViewController ()
@property (nonatomic, strong) UIButton *editButton;
@end

@implementation ScoreDefineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分设置";
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    [self setupNavView];
}

- (void)setupNavView {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [rightButton setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    WEAK_SELF
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if ([rightButton.titleLabel.text isEqualToString:@"编辑"]) {
            [rightButton setTitle:@"保存" forState:UIControlStateNormal];
        }else {
            [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        }
    }];
    self.editButton = rightButton;
    [self nyx_setupRightWithCustomView:rightButton];
}
@end
