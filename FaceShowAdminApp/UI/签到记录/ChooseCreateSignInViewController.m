//
//  ChooseCreateSignInViewController.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/18.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ChooseCreateSignInViewController.h"
#import "CreateSignInViewController.h"
#import "MultipleCreateViewController.h"

@interface ChooseCreateSignInViewController ()

@end

@implementation ChooseCreateSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择创建方式";
    [self setupUI];
}

- (void)setupUI{

    UIButton *create = [UIButton buttonWithType:UIButtonTypeCustom];
    create.backgroundColor = [UIColor whiteColor];
    [create setTitle:@"创建签到" forState:UIControlStateNormal];
    [create setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.view addSubview:create];
    [create mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
    }];
    WEAK_SELF
    [[create rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [TalkingData trackEvent:@"创建签到"];
        CreateSignInViewController *create = [[CreateSignInViewController alloc] init];
        [self.navigationController pushViewController:create animated:YES];
    }];

    UIButton *multipleCreate = [UIButton buttonWithType:UIButtonTypeCustom];
    multipleCreate.backgroundColor = [UIColor whiteColor];
    [multipleCreate setTitle:_isMultiple?@"一键创建班级签到":@"批量创建签到" forState:UIControlStateNormal];
    [multipleCreate setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.view addSubview:multipleCreate];
    [multipleCreate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(create.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
    }];
    [[multipleCreate rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [TalkingData trackEvent:self.isMultiple?@"一键创建班级签到":@"批量创建签到"];
        MultipleCreateViewController *create = [[MultipleCreateViewController alloc] init];
        create.isDefault = self.isMultiple;
        [self.navigationController pushViewController:create animated:YES];
    }];

}


@end
