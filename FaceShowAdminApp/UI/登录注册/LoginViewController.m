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
#import "YXInputView.h"
#import "GetVerifyCodeRequest.h"
#import "LoginUtils.h"

@interface LoginViewController ()
@property (nonatomic, strong) YXInputView *inputView;
@property (nonatomic, strong) LoginActionView *loginView;
@property (nonatomic, strong) GetVerifyCodeRequest *getVerifyCodeRequest;
/*
@property (nonatomic, strong) AccountInputView *accountView;
@property (nonatomic, strong) PasswordInputView *passwordView;
 */
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
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"管理登录背景"]];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    }];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    [self.contentView addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.contentView.mas_safeAreaLayoutGuideTop).offset(100);
        } else {
            // Fallback on earlier versions
            make.top.mas_equalTo(100);
        }
        make.centerX.mas_equalTo(0);
    }];
    UIButton *forgetPwdButton = [[UIButton alloc]init];
    [forgetPwdButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPwdButton setTitleColor:[UIColor colorWithHexString:@"9D9CA1"] forState:UIControlStateNormal];
    forgetPwdButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [forgetPwdButton addTarget:self action:@selector(goForgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:forgetPwdButton];
    [forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.contentView.mas_safeAreaLayoutGuideBottom).offset(-154);
        } else {
            // Fallback on earlier versions
            make.bottom.mas_equalTo(-154);
        }
        make.right.mas_equalTo(-37);
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
        make.bottom.mas_equalTo(forgetPwdButton.mas_top).mas_offset(-10);
        make.size.mas_equalTo(CGSizeMake(300*kPhoneWidthRatio, 46));
    }];

    self.inputView = [[YXInputView alloc] init];
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(self.loginView.mas_top).offset(-30);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(120);
    }];
    self.inputView.sendVerifyCodeBlock = ^(NSString * _Nonnull telPhoneNumber) {
        STRONG_SELF
        [self sendVerifyCodeWithPhoneNumber:telPhoneNumber];
    };
    self.inputView.btnEnabledBlock = ^(BOOL enabled) {
        STRONG_SELF
        self.loginView.isActive = enabled;
    };

    UIButton *quickbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quickbtn setTitle:@"快速登录" forState:0];
    quickbtn.selected = YES;
    [quickbtn setTitleColor:[UIColor colorWithHexString:@"181928"] forState:UIControlStateSelected];
    [quickbtn setTitleColor:[UIColor colorWithHexString:@"929699"] forState:UIControlStateNormal];
    quickbtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [self.view addSubview:quickbtn];
    [quickbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.inputView.mas_top).offset(-20);
        make.left.mas_equalTo(self.inputView.mas_left).offset(50);
        make.size.mas_equalTo(CGSizeMake(80, 35));
    }];
    UIView *blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor colorWithHexString:@"4C9EEB"];
    [self.view addSubview:blueView];
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(quickbtn);
        make.size.mas_equalTo(CGSizeMake(30, 2));
        make.top.mas_equalTo(quickbtn.mas_bottom).offset(5);
    }];

    UIButton *login = [quickbtn clone];
    [login setTitle:@"普通登录" forState:0];
    [self.view addSubview:login];
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.inputView.mas_top).offset(-20);
        make.right.mas_equalTo(self.inputView.mas_right).offset(-50);
        make.size.mas_equalTo(CGSizeMake(80, 35));
    }];

    [[quickbtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        quickbtn.selected = YES;
        login.selected = NO;
        self.inputView.type = YXInputViewType_QuickLogin;
        [blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(quickbtn);
            make.size.mas_equalTo(CGSizeMake(30, 2));
            make.top.mas_equalTo(quickbtn.mas_bottom).offset(5);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            [self.inputView setFocus];
        }];
    }];


    [[login rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        login.selected = YES;
        quickbtn.selected = NO;
        self.inputView.type = YXInputViewType_Default;
        [blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(login);
            make.size.mas_equalTo(CGSizeMake(30, 2));
            make.top.mas_equalTo(login.mas_bottom).offset(5);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            [self.inputView setFocus];
        }];
    }];

//    NSString *lastAccount = (NSString *)[[NSUserDefaults standardUserDefaults]valueForKey:@"last_login_user_mobile"];
    
    self.loginView.isActive = NO;
}
- (void)goLogin {
    [self.view endEditing:YES];
    [self.view nyx_startLoading];
    NSString *telNumber = [self.inputView.telPhoneNumber yx_stringByTrimmingCharacters];
    WEAK_SELF
    AppLoginType type = self.inputView.type == YXInputViewType_Default?AppLoginType_AccountLogin:AppLoginType_AppCodeLogin;
    [LoginDataManager loginWithName:telNumber password:self.inputView.password loginType:type completeBlock:^(NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            if (type ==YXInputViewType_Default) {
                [self.inputView clearPassWord];
                self.loginView.isActive = NO;
            }
            return;
        }
    }];
}

- (void)goForgetPassword {
    [TalkingData trackEvent:@"忘记密码"];
    ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendVerifyCodeWithPhoneNumber:(NSString *)phoneNumber{
    if (![LoginUtils isPhoneNumberValid:phoneNumber]) {
        [self.view nyx_showToast:@"请输入正确的手机号码"];
        return;
    }
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.inputView startTimer];
    [self.getVerifyCodeRequest stopRequest];
    self.getVerifyCodeRequest = [[GetVerifyCodeRequest alloc]init];
    self.getVerifyCodeRequest.mobile = phoneNumber;
    [self.getVerifyCodeRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.inputView stopTimer];
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view nyx_showToast:@"验证码已发送，请注意查收"];
    }];
}


@end

