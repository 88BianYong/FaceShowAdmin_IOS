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
#import "SignInTypeView.h"
#import "SignInLocationView.h"
#import "SignInPlaceViewController.h"

@interface CreateSignInViewController ()<UITextViewDelegate>
@property (nonatomic, strong) SAMTextView *titleView;
@property (nonatomic, strong) SAMTextView *promptView;
@property (nonatomic, strong) SignInDateTimeView *dateView;
@property (nonatomic, strong) SignInDateTimeView *begintimeView;
@property (nonatomic, strong) SignInDateTimeView *endtimeView;
@property (nonatomic, strong) SignInTypeView *codeTypeView;
@property (nonatomic, strong) SignInSwitchView *dynamicView;
@property (nonatomic, strong) SignInTypeView *locationTypeView;
@property (nonatomic, strong) SignInLocationView *locatonView;
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
    
    UIView *signInContainerView = [[UIView alloc]init];
    signInContainerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:signInContainerView];
    [signInContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(dateContainerView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(0);
    }];
    
    UIView *signTypeBgView = [[UIView alloc]init];
    signTypeBgView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [signInContainerView addSubview:signTypeBgView];
    [signTypeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(45.f);
    }];
    UILabel *signTypeLabel = [[UILabel alloc]init];
    signTypeLabel.backgroundColor = [UIColor clearColor];
    signTypeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    signTypeLabel.font = [UIFont boldSystemFontOfSize:14.f];
    signTypeLabel.text = @"签到类型";
    [signTypeBgView addSubview:signTypeLabel];
    [signTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.top.bottom.mas_equalTo(0);
    }];
    
    self.codeTypeView = [[SignInTypeView alloc]init];
    self.codeTypeView.title = @"扫码签到";
    [signInContainerView addSubview:self.codeTypeView];
    [self.codeTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(signTypeLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];

    UIView *v3 = [v1 clone];
    [signInContainerView addSubview:v3];
    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.codeTypeView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    self.dynamicView = [[SignInSwitchView alloc]init];
    self.dynamicView.title = @"使用动态刷新的二维码";
    [signInContainerView addSubview:self.dynamicView];
    [self.dynamicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(v3.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    UIView *v4 = [v1 clone];
    [signInContainerView addSubview:v4];
    [v4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.dynamicView.mas_bottom);
        make.height.mas_equalTo(5);
    }];
    
    self.locationTypeView = [[SignInTypeView alloc]init];
    self.locationTypeView.title = @"位置签到";
    [signInContainerView addSubview:self.locationTypeView];
    [self.locationTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(v4.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    UIView *v5 = [v1 clone];
    [signInContainerView addSubview:v5];
    v5.hidden = YES;
    [v5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.locationTypeView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    self.locatonView = [[SignInLocationView alloc]init];
    self.locatonView.hidden = YES;
    self.locatonView.placeholderStr = @"请指定签到地点";
    [self.locatonView setSelectionBlock:^{
        STRONG_SELF
        DDLogDebug(@"Location selection");
        [self showSignInPlaceSelectionVC];
        [self refreshSubmitButton];
    }];
    [signInContainerView addSubview:self.locatonView];
    [self.locatonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(v5.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    
    self.codeTypeView.isSelected = YES;
    [self.codeTypeView setChooseSignTypeBlock:^(void) {
        STRONG_SELF
        self.locationTypeView.isSelected = NO;
        self.dynamicView.hidden = NO;
        v3.hidden = NO;
        v5.hidden = YES;
        self.locatonView.hidden = YES;
        [v4 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.dynamicView.mas_bottom);
            make.height.mas_equalTo(5);
        }];
        [self.locationTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(v4.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.bottom.mas_equalTo(0);
        }];
        [self refreshSubmitButton];
    }];
    [self.locationTypeView setChooseSignTypeBlock:^(void) {
        STRONG_SELF
        self.codeTypeView.isSelected = NO;
        v5.hidden = NO;
        self.locatonView.hidden = NO;
        self.dynamicView.hidden = YES;
        v3.hidden = YES;
        [v4 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.codeTypeView.mas_bottom);
            make.height.mas_equalTo(5);
        }];
        [self.locationTypeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(v4.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        [self refreshSubmitButton];
    }];
    
    UIView *signPrmoptBgView = [[UIView alloc]init];
    signPrmoptBgView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:signPrmoptBgView];
    [signPrmoptBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(signInContainerView.mas_bottom);
        make.height.mas_equalTo(45.f);
    }];
    UILabel *signPromptLabel = [[UILabel alloc]init];
    signPromptLabel.backgroundColor = [UIColor clearColor];
    signPromptLabel.textColor = [UIColor colorWithHexString:@"999999"];
    signPromptLabel.font = [UIFont boldSystemFontOfSize:14.f];
    signPromptLabel.text = @"签到成功提示语";
    [signPrmoptBgView addSubview:signPromptLabel];
    [signPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.top.bottom.mas_equalTo(0);
    }];
    
    self.promptView = [[SAMTextView alloc]init];
    self.promptView.backgroundColor = [UIColor whiteColor];
    self.promptView.font = [UIFont systemFontOfSize:14];
    self.promptView.textColor = [UIColor colorWithHexString:@"333333"];
    self.promptView.text = @"签到成功!";
    dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.promptView.typingAttributes = dic;
    self.promptView.textContainerInset = UIEdgeInsetsMake(20, 15, 20, 15);
    self.promptView.delegate = self;
    self.promptView.scrollEnabled = NO;
    [self.contentView addSubview:self.promptView];
    [self.promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(signPrmoptBgView.mas_bottom);
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
        if (!self.codeTypeView.isSelected && self.locationTypeView.isSelected && [self.locatonView.title length] <= 0) {
            self.submitButton.enabled = NO;
        }else {
            self.submitButton.enabled = YES;
        }
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

- (void)showSignInPlaceSelectionVC {
    SignInPlaceViewController *vc = [[SignInPlaceViewController alloc]init];
    WEAK_SELF
    [vc setSelectBlock:^(BMKPoiInfo *info) {
        STRONG_SELF
        self.locatonView.title = info.name;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submit {
    NSString *date = [self.dateView.content stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    NSString *start = [NSString stringWithFormat:@"%@ %@",date,self.begintimeView.content];
    NSString *end = [NSString stringWithFormat:@"%@ %@",date,self.endtimeView.content];
    int i = [start isAscendingCompareDate:end];
    if (i < 1) {
        [self.view nyx_showToast:@"结束时间必须大于开始时间"];
        return;
    }
    if (self.dynamicView.isOn) {
        [TalkingData trackEvent:@"使用动态二维码"];
    }
    [self.createSignInRequest stopRequest];
    self.createSignInRequest = [[CreateSignInRequest alloc]init];
    self.createSignInRequest.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    self.createSignInRequest.title = self.titleView.text;
    self.createSignInRequest.successPrompt = self.promptView.text;
    self.createSignInRequest.antiCheat = [NSString stringWithFormat:@"%@",@(YES)];
    self.createSignInRequest.qrcodeRefreshRate = [NSString stringWithFormat:@"%@",@(self.dynamicView.isOn)];
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
