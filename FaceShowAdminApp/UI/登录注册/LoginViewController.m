//
//  LoginViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountInputView.h"
#import "PasswordInputView.h"
#import "LoginActionView.h"
#import "ForgotPasswordViewController.h"
#import "LoginDataManager.h"

@interface LoginViewController ()
@property (nonatomic, strong) AccountInputView *accountView;
@property (nonatomic, strong) PasswordInputView *passwordView;
@property (nonatomic, strong) LoginActionView *loginView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bottomHeightWhenKeyboardShows = 20;
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setupUI {
    self.scrollView.bounces = NO;
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景"]];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    }];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    [self.contentView addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(127*kPhoneHeightRatio);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(175*kPhoneWidthRatio, 100*kPhoneWidthRatio));
    }];
    UIButton *forgetPwdButton = [[UIButton alloc]init];
    [forgetPwdButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPwdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    forgetPwdButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [forgetPwdButton addTarget:self action:@selector(goForgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:forgetPwdButton];
    [forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-44*kPhoneHeightRatio);
        make.right.mas_equalTo(-(SCREEN_WIDTH-250*kPhoneWidthRatio)/2);
    }];
    LoginActionView *loginView = [[LoginActionView alloc]init];
    self.loginView = loginView;
    loginView.title = @"登 录";
    WEAK_SELF
    [loginView setActionBlock:^{
        STRONG_SELF
        [self goLogin];
    }];
    [self.contentView addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(forgetPwdButton.mas_top).mas_offset(-24);
        make.size.mas_equalTo(CGSizeMake(250*kPhoneWidthRatio, 40));
    }];
    self.passwordView = [[PasswordInputView alloc]init];
    self.passwordView.inputView.textField.tintColor = [UIColor whiteColor];
    [self.passwordView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshLoginButton];
    }];
    [self.contentView addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.loginView.mas_top).mas_offset(-20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(250*kPhoneWidthRatio, 40));
    }];
    self.accountView = [[AccountInputView alloc]init];
    self.accountView.inputView.textField.tintColor = [UIColor whiteColor];
    [self.accountView setTextChangeBlock:^{
        STRONG_SELF
        //        if (self.accountView.text.length>16) {
        //            self.accountView.inputView.textField.text = [self.accountView.text substringToIndex:16];
        //        }
        [self refreshLoginButton];
    }];
    [self.contentView addSubview:self.accountView];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.passwordView.mas_top).mas_offset(-10);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(250*kPhoneWidthRatio, 40));
    }];
    NSString *lastAccount = (NSString *)[[NSUserDefaults standardUserDefaults]valueForKey:@"last_login_user_mobile"];
    self.accountView.inputView.textField.text = lastAccount;
    [self refreshLoginButton];
}

- (void)refreshLoginButton {
    if (!isEmpty([self.accountView text])&&!isEmpty([self.passwordView text])) {
        self.loginView.isActive = YES;
    }else {
        self.loginView.isActive = NO;
    }
}

- (void)goLogin {
    [self.view nyx_startLoading];
    WEAK_SELF
    [LoginDataManager loginWithName:self.accountView.text password:self.passwordView.text completeBlock:^(NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            self.passwordView.inputView.textField.text = @"";
            [self refreshLoginButton];
            return;
        }
    }];
}

- (void)goForgetPassword {
    [TalkingData trackEvent:@"忘记密码"];
    ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

