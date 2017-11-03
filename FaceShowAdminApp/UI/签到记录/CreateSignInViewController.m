//
//  CreateSignInViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CreateSignInViewController.h"
#import <SAMTextView.h>
#import "SignInDateTimeView.h"
#import "SignInSwitchView.h"
#import "SignInDateTimeSettingView.h"
#import "AlertView.h"
#import "CreateSignInRequest.h"

@interface CreateSignInViewController ()<UITextViewDelegate>
@property (nonatomic, strong) SAMTextView *titleView;
@property (nonatomic, strong) SAMTextView *promptView;
@property (nonatomic, strong) SignInDateTimeView *dateView;
@property (nonatomic, strong) SignInDateTimeView *begintimeView;
@property (nonatomic, strong) SignInDateTimeView *endtimeView;
@property (nonatomic, strong) SignInSwitchView *validView;
@property (nonatomic, strong) SignInSwitchView *dynamicView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) CreateSignInRequest *createSignInRequest;
@end

@implementation CreateSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"新建签到";
    self.submitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [self.submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.enabled = NO;
    [self nyx_setupRightWithCustomView:self.submitButton];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.titleView = [[SAMTextView alloc]init];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.font = [UIFont boldSystemFontOfSize:16];
    self.titleView.textColor = [UIColor colorWithHexString:@"333333"];
    NSString *placeholderStr = @"签到标题（最多20字）";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:placeholderStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"cccccc"] range:NSMakeRange(0, placeholderStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:self.titleView.font range:NSMakeRange(0, placeholderStr.length)];
    self.titleView.attributedPlaceholder = attrStr;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont boldSystemFontOfSize:16]};
    self.titleView.typingAttributes = dic;
    self.titleView.textContainerInset = UIEdgeInsetsMake(20, 15, 20, 15);
    self.titleView.delegate = self;
    self.titleView.scrollEnabled = NO;
    [self.contentView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(60);
    }];
    UIView *dateContainerView = [[UIView alloc]init];
    dateContainerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:dateContainerView];
    [dateContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(0);
    }];
    self.dateView = [[SignInDateTimeView alloc]init];
    self.dateView.title = @"签到日期";
    WEAK_SELF
    [self.dateView setSelectionBlock:^{
        STRONG_SELF
        [self showSelectionViewFrom:self.dateView];
    }];
    [dateContainerView addSubview:self.dateView];
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    UIView *v1 = [[UIView alloc]init];
    v1.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [dateContainerView addSubview:v1];
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.dateView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    self.begintimeView = [[SignInDateTimeView alloc]init];
    self.begintimeView.title = @"开始时间";
    [self.begintimeView setSelectionBlock:^{
        STRONG_SELF
        [self showSelectionViewFrom:self.begintimeView];
    }];
    [dateContainerView addSubview:self.begintimeView];
    [self.begintimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(v1.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    UIView *v2 = [v1 clone];
    [dateContainerView addSubview:v2];
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.begintimeView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    self.endtimeView = [[SignInDateTimeView alloc]init];
    self.endtimeView.title = @"结束时间";
    [self.endtimeView setSelectionBlock:^{
        STRONG_SELF
        [self showSelectionViewFrom:self.endtimeView];
    }];
    [dateContainerView addSubview:self.endtimeView];
    [self.endtimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(v2.mas_bottom);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    UIView *switchContainerView = [[UIView alloc]init];
    switchContainerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:switchContainerView];
    [switchContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(dateContainerView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(0);
    }];
    self.validView = [[SignInSwitchView alloc]init];
    self.validView.title = @"只在签到时间内签到有效";
    [switchContainerView addSubview:self.validView];
    [self.validView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    UIView *v3 = [v1 clone];
    [switchContainerView addSubview:v3];
    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.validView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    self.dynamicView = [[SignInSwitchView alloc]init];
    self.dynamicView.title = @"使用动态刷新的二维码";
    [switchContainerView addSubview:self.dynamicView];
    [self.dynamicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(v3.mas_bottom);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    self.promptView = [[SAMTextView alloc]init];
    self.promptView.backgroundColor = [UIColor whiteColor];
    self.promptView.font = [UIFont boldSystemFontOfSize:14];
    self.promptView.textColor = [UIColor colorWithHexString:@"333333"];
    placeholderStr = @"签到成功提示语（最多20字）";
    attrStr = [[NSMutableAttributedString alloc]initWithString:placeholderStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"cccccc"] range:NSMakeRange(0, placeholderStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:self.promptView.font range:NSMakeRange(0, placeholderStr.length)];
    self.promptView.attributedPlaceholder = attrStr;
    dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont boldSystemFontOfSize:14]};
    self.promptView.typingAttributes = dic;
    self.promptView.textContainerInset = UIEdgeInsetsMake(20, 15, 20, 15);
    self.promptView.delegate = self;
    self.promptView.scrollEnabled = NO;
    [self.contentView addSubview:self.promptView];
    [self.promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(switchContainerView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(-40);
    }];
}

- (void)refreshSubmitButton {
    if (self.titleView.text.length>0
        && self.promptView.text.length>0
        && self.dateView.content.length>0
        && self.begintimeView.content.length>0
        && self.endtimeView.content.length>0) {
        self.submitButton.enabled = YES;
    }else {
        self.submitButton.enabled = NO;
    }
}

- (void)showSelectionViewFrom:(SignInDateTimeView *)from {
    [self.titleView resignFirstResponder];
    [self.promptView resignFirstResponder];
    SignInDateTimeSettingView *settingView = [[SignInDateTimeSettingView alloc]init];
    if (from == self.dateView) {
        settingView.mode = UIDatePickerModeDate;
    }else {
        settingView.mode = UIDatePickerModeTime;
    }
    WEAK_SELF
    [settingView setCancelBlock:^{
        STRONG_SELF
        [self.alertView hide];
    }];
    [settingView setConfirmBlock:^(NSString *result){
        STRONG_SELF
        from.content = result;
        [self refreshSubmitButton];
        [self.alertView hide];
    }];
    self.alertView = [[AlertView alloc]init];
    self.alertView.contentView = settingView;
    self.alertView.hideWhenMaskClicked = YES;
    [self.alertView showWithLayout:^(AlertView *view) {
        view.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        [UIView animateWithDuration:0.3 animations:^{
            view.contentView.frame = CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 250);
        }];
    }];
}

- (void)submit {
    [self.createSignInRequest stopRequest];
    self.createSignInRequest = [[CreateSignInRequest alloc]init];
    self.createSignInRequest.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    self.createSignInRequest.title = self.titleView.text;
    self.createSignInRequest.successPrompt = self.promptView.text;
    self.createSignInRequest.antiCheat = [NSString stringWithFormat:@"%@",@(self.validView.isOn)];
    self.createSignInRequest.qrcodeRefreshRate = [NSString stringWithFormat:@"%@",@(self.dynamicView.isOn)];
    NSString *date = [self.dateView.content stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    NSString *start = [NSString stringWithFormat:@"%@ %@",date,self.begintimeView.content];
    NSString *end = [NSString stringWithFormat:@"%@ %@",date,self.endtimeView.content];
    self.createSignInRequest.startTime = start;
    self.createSignInRequest.endTime = end;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.createSignInRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        BLOCK_EXEC(self.comleteBlock);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGRect rect = [textView convertRect:textView.bounds toView:self.scrollView];
    [self.scrollView scrollRectToVisible:rect animated:YES];    
}

- (void)textViewDidChange:(UITextView *)textView {
    [self refreshSubmitButton];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    NSString *finalString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (finalString.length > 20) {
        return NO;
    }
    return YES;
}

@end
