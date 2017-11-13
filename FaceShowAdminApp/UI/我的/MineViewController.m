//
//  MineViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MineViewController.h"
#import "ClassSelectionViewController.h"
#import "MyInfoViewController.h"

@interface MineViewController ()
@property (nonatomic, strong) UIButton *avatarBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *classDescLabel;
@property (nonatomic, strong) UILabel *classNameLabel;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头像背景"]];
    backImageView.clipsToBounds = YES;
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(239);
    }];
    
    self.avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.avatarBtn.clipsToBounds = YES;
    self.avatarBtn.layer.cornerRadius = 6;
    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.avatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 55, 55)]];
    [self.view addSubview:self.avatarBtn];
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.text = [UserManager sharedInstance].userModel.realName;
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(self.avatarBtn.mas_bottom).offset(10.75f);
    }];
    
    self.classDescLabel = [[UILabel alloc] init];
    self.classDescLabel.font = [UIFont systemFontOfSize:13];
    self.classDescLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.classDescLabel.textAlignment = NSTextAlignmentCenter;
    self.classDescLabel.text = [UserManager sharedInstance].userModel.currentClass.desc;
    [self.view addSubview:self.classDescLabel];
    [self.classDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(19.25f);
    }];
    
    self.classNameLabel = [[UILabel alloc] init];
    self.classNameLabel.font = [UIFont systemFontOfSize:13];
    self.classNameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.classNameLabel.textAlignment = NSTextAlignmentCenter;
    self.classNameLabel.text = [UserManager sharedInstance].userModel.currentClass.clazsName;
    [self.view addSubview:self.classNameLabel];
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(self.classDescLabel.mas_bottom).offset(3);
    }];
    
    UIButton *changeClassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeClassBtn.clipsToBounds = YES;
    changeClassBtn.layer.cornerRadius = 6;
    changeClassBtn.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
    changeClassBtn.layer.borderWidth = 1;
    changeClassBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [changeClassBtn setTitle:@"更换班级" forState:UIControlStateNormal];
    [changeClassBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [changeClassBtn setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateHighlighted];
    [changeClassBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [changeClassBtn setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateHighlighted];
    [changeClassBtn addTarget:self action:@selector(changeClassBtnAction) forControlEvents:UIControlEventTouchUpInside];
    changeClassBtn.hidden = [UserManager sharedInstance].userModel.clazsInfos.count < 2;
    [self.view addSubview:changeClassBtn];
    [changeClassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.classNameLabel.mas_bottom).offset(10.5f);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(80, 26));
    }];
    
    UIButton *classHomeBtn = [self optionBtnWithTitle:@"班级首页" normalImage:@"首页icon正常态" highlightedImage:@"首页icon点击态"];
    [self.view addSubview:classHomeBtn];
    [classHomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backImageView.mas_bottom).offset(44);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    
    UIButton *mineInfoBtn = [self optionBtnWithTitle:@"我的资料" normalImage:@"我的icon正常态" highlightedImage:@"我的icon点击态"];
    [self.view addSubview:mineInfoBtn];
    [mineInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(classHomeBtn.mas_bottom).offset(40);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    [logoutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateNormal];
    [logoutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0068bd"]] forState:UIControlStateHighlighted];
    [logoutBtn addTarget:self action:@selector(logoutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
}

- (UIButton *)optionBtnWithTitle:(NSString *)title normalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [btn addTarget:self action:@selector(optionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - setupObserver
- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kUpdateUserInfoSucceedNotification" object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.avatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 55, 55)]];
        self.nameLabel.text = [UserManager sharedInstance].userModel.realName;
    }];
}

#pragma mark - actions
- (void)changeClassBtnAction {
    ClassSelectionViewController *selectionVC = [[ClassSelectionViewController alloc] init];
    [self.navigationController pushViewController:selectionVC animated:YES];
}

- (void)logoutBtnAction {
    [UserManager sharedInstance].loginStatus = NO;
}

- (void)optionBtnAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"班级首页"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kClassDidSelectNotification object:nil];
    } else if ([sender.titleLabel.text isEqualToString:@"我的资料"]) {
        MyInfoViewController *vc = [[MyInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
