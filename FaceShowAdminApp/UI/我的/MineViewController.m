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
#import "TrainingProfileViewController.h"
#import "MyTrainingProjectViewController.h"
#import "YXDrawerController.h"
#import "ProjectListViewController.h"
#import "ForgotPasswordViewController.h"
#import "AboutFaceShowViewController.h"
#import "YXInitRequest.h"

@interface MineViewController ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *projectLabel;
@property (nonatomic, strong) UILabel *classNameLabel;
@property (nonatomic, strong) UILabel *roleLabel;
@property (nonatomic, strong) NSString *roles;
@property (nonatomic, strong) NSMutableArray *moduleArray;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRoles];
    [self setupModules];
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRoles {
    GetUserRolesRequestItem_data *data = [UserManager sharedInstance].userModel.roleRequestItem.data;
    NSMutableArray *array = [NSMutableArray array];
    if ([data roleExists:UserRole_PlatformAdmin]) {
        [array addObject:@"平台管理员"];
    }
    if ([data roleExists:UserRole_AreaAdmin]) {
        [array addObject:@"区域管理员"];
    }
    if ([data roleExists:UserRole_ProjectAdmin]||[data roleExists:UserRole_ProjectSteward]) {
        [array addObject:@"机构管理员"];
    }
    if ([data roleExists:UserRole_ProvinceAdmin]) {
        [array addObject:@"省级管理员"];
    }
    if ([data roleExists:UserRole_Teacher]||[data roleExists:UserRole_UnknownTeacher]) {
        [array addObject:@"班主任"];
    }
    if ([data roleExists:UserRole_Student]) {
        [array addObject:@"学员"];
    }
    self.roles = [array componentsJoinedByString:@"|"];
}

- (void)setupModules {
    GetUserRolesRequestItem_data *data = [UserManager sharedInstance].userModel.roleRequestItem.data;
    NSMutableArray *array = [NSMutableArray array];
    if ([data roleExists:UserRole_PlatformAdmin]||
        [data roleExists:UserRole_AreaAdmin]||
        [data roleExists:UserRole_ProjectAdmin]||
        [data roleExists:UserRole_ProjectSteward]||
        [data roleExists:UserRole_ProvinceAdmin]) {
        [array addObject:@"培训概况"];
    }
    if ([data roleExists:UserRole_ProvinceAdmin]) {
        [array addObject:@"项目列表"];
    }
    if ([data roleExists:UserRole_ProjectAdmin]||[data roleExists:UserRole_ProjectSteward]) {
        [array addObject:@"我的项目"];
    }
    if ([data roleExists:UserRole_Teacher]||[data roleExists:UserRole_UnknownTeacher]) {
        [array addObject:@"我的班级"];
    }
    self.moduleArray = array;
}

#pragma mark - setupUI
- (void)setupUI {
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头像背景"]];
    backImageView.clipsToBounds = YES;
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 6;
    self.avatarImageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"班级圈大默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
    }];
    [self.view addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(24);
        } else {
            make.top.mas_equalTo(44);
        }
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
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(10.75f);
        make.height.mas_equalTo(20);
    }];
    self.roleLabel = [[UILabel alloc] init];
    self.roleLabel.font = [UIFont systemFontOfSize:13];
    self.roleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.roleLabel.textAlignment = NSTextAlignmentCenter;
    self.roleLabel.numberOfLines = 0;
    self.roleLabel.text = self.roles;
    [self.view addSubview:self.roleLabel];
    [self.roleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
    }];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.roleLabel.mas_bottom).mas_offset(20);
    }];
    
    UIView *topView = backImageView;
    for (NSString *item in self.moduleArray) {
        UIButton *btn = [self optionBtnWithItem:item];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).offset(30);
            make.centerX.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
        }];
        topView = btn;
    }
    
    UIButton *btn = [self optionBtnWithTitle:@"我的资料" normalImage:@"我的icon正常态" highlightedImage:@"我的icon点击态"];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    UIButton *password = [self optionBtnWithTitle:@"修改密码" normalImage:@"忘记密码icon正常态管理端" highlightedImage:@"忘记密码icon选择态管理端"];
    [self.view addSubview:password];
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    UIButton *about = [self optionBtnWithTitle:@"关于我们" normalImage:@"关于" highlightedImage:@"关于点击"];
    if ([YXInitHelper sharedHelper].hasNewVersion) {
        UIView *redPointView = [[UIView alloc] init];
        redPointView.layer.cornerRadius = 4.5f;
        redPointView.backgroundColor = [UIColor colorWithHexString:@"ff0000"];
        [about.titleLabel addSubview:redPointView];
        [redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(about.titleLabel.mas_right);
            make.top.mas_equalTo(-3.5);
            make.size.mas_equalTo(CGSizeMake(9, 9));
        }];
    }
    [self.view addSubview:about];
    [about mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(password.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
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
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    
    UILabel *versionLabel = [[UILabel alloc]init];
    versionLabel.textColor = [UIColor colorWithHexString:@"a4acb8"];
    versionLabel.text = [NSString stringWithFormat:@"版本号：V%@",[ConfigManager sharedInstance].clientVersion];
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(logoutBtn.mas_top).mas_offset(-20);
        make.centerX.mas_equalTo(0);
    }];
}

- (UIButton *)optionBtnWithItem:(NSString *)item {
    UIButton *btn = nil;
    if ([item isEqualToString:@"培训概况"]) {
        btn = [self optionBtnWithTitle:@"培训概况" normalImage:@"培训概况" highlightedImage:@"培训概况点击"];
    }
    if ([item isEqualToString:@"项目列表"]) {
        btn = [self optionBtnWithTitle:@"项目列表" normalImage:@"我的项目" highlightedImage:@"我的项目点击"];
    }
    if ([item isEqualToString:@"我的项目"]) {
        btn = [self optionBtnWithTitle:@"我的项目" normalImage:@"我的项目" highlightedImage:@"我的项目点击"];
    }
    if ([item isEqualToString:@"我的班级"]) {
        btn = [self optionBtnWithTitle:@"我的班级" normalImage:@"我的班级" highlightedImage:@"我的班级点击"];
    }
    return btn;
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
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager sharedInstance].userModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"班级圈大默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
        }];
        self.nameLabel.text = [UserManager sharedInstance].userModel.realName;
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"kUpdateProjectInfoNotification" object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        self.projectLabel.text = [UserManager sharedInstance].userModel.currentProject.projectName;
    }];
}

#pragma mark - actions

- (void)logoutBtnAction {
    [TalkingData trackEvent:@"退出登录"];
    [UserManager sharedInstance].loginStatus = NO;
}

- (void)optionBtnAction:(UIButton *)sender {
    [TalkingData trackEvent:[NSString stringWithFormat:@"点击%@",sender.titleLabel.text]];
    if ([sender.titleLabel.text isEqualToString:@"我的班级"]) {
        ClassSelectionViewController *selectionVC = [[ClassSelectionViewController alloc] init];
        [self.navigationController pushViewController:selectionVC animated:YES];
    } else if ([sender.titleLabel.text isEqualToString:@"我的资料"]) {
        MyInfoViewController *vc = [[MyInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([sender.titleLabel.text isEqualToString:@"培训概况"]) {
        if ([[YXDrawerController drawer].paneViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)[YXDrawerController drawer].paneViewController;
            if ([navi.viewControllers[0] isKindOfClass:[TrainingProfileViewController class]]) {
                [YXDrawerController hideDrawer];
                return;
            }
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kTrainingProfileDidSelectNotification object:nil];
    } else if ([sender.titleLabel.text isEqualToString:@"我的项目"]) {
        if ([[YXDrawerController drawer].paneViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)[YXDrawerController drawer].paneViewController;
            if ([navi.viewControllers[0] isKindOfClass:[MyTrainingProjectViewController class]]) {
                [YXDrawerController hideDrawer];
                return;
            }
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kMyProjectDidSelectNotification object:nil];
    }else if ([sender.titleLabel.text isEqualToString:@"项目列表"]) {
        if ([[YXDrawerController drawer].paneViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)[YXDrawerController drawer].paneViewController;
            if ([navi.viewControllers[0] isKindOfClass:[ProjectListViewController class]]) {
                [YXDrawerController hideDrawer];
                return;
            }
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kProjectListDidSelectNotification object:nil];
    }else if ([sender.titleLabel.text isEqualToString:@"修改密码"]) {
        ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc] init];
        vc.isModify = YES;
        vc.phoneNum = [UserManager sharedInstance].userModel.mobilePhone;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"关于我们"]){
        [sender.titleLabel removeSubviews];
        AboutFaceShowViewController *about = [[AboutFaceShowViewController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
    }
}

@end
