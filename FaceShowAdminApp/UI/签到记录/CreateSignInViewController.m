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
#import "GroupListRequest.h"
#import "SignInDetailRequest.h"
#import "UpdateSignInRequest.h"
#import "SignGroupPlaceView.h"
#import "SignInTypeSelectView.h"
#import "SignInScopeSelectView.h"
#import "FDActionSheetView.h"
#import "SignInListViewController.h"
#import "TaskViewController.h"

@interface CreateSignInViewController ()<UITextViewDelegate>
@property (nonatomic, strong) SAMTextView *titleView;
@property (nonatomic, strong) SignInDateTimeView *dateView;
@property (nonatomic, strong) SignInDateTimeView *begintimeView;
@property (nonatomic, strong) SignInDateTimeView *endtimeView;
@property (nonatomic, strong) SAMTextView *promptView;
@property (nonatomic, strong) UIView *signInTypeContainerView;
@property (nonatomic, strong) SignInTypeSelectView *signTypeSelectView;
@property (nonatomic, strong) SignInScopeSelectView *signScopeSelectView;
@property (nonatomic, strong) SignInSwitchView *dynamicView;
@property (nonatomic, strong) SignInLocationView *locatonView;
@property (nonatomic, strong) SignGroupPlaceView *placeView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) CreateSignInRequest *createSignInRequest;
@property (nonatomic, strong) GroupListRequest *grouplistRequest;
@property (nonatomic, strong) SignInDetailRequest *detailRequest;
@property (nonatomic, strong) UpdateSignInRequest *updateRequest;
@property (nonatomic, strong) BMKPoiInfo *selectedPoi;
@property (nonatomic, strong) NSDate *signInDate;
@property (nonatomic, strong) NSDate *beginTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, copy) NSArray *groupSignInfo;
@property (nonatomic, strong) NSString *defaultSignInPosition;
@property (nonatomic, copy) NSArray *defaultSignInExts;
@end

@implementation CreateSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.submitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    WEAK_SELF
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (isEmpty(self.stepId)) {
            [self submit];
        }else{
            [self updateSignInRequest];
        }
    }];
    self.submitButton.enabled = NO;
    [self nyx_setupRightWithCustomView:self.submitButton];
    [self setupUI];
    [self requestGroupList];
    if (self.stepId) {
        self.navigationItem.title = @"修改签到";
        [self requestDetail];
    }else{
        self.navigationItem.title = @"新建签到";
    }
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

    UIView *signPrmoptBgView = [[UIView alloc]init];
    signPrmoptBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:signPrmoptBgView];
    [signPrmoptBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(dateContainerView.mas_bottom).offset(5);
    }];
    UILabel *signPromptLabel = [[UILabel alloc]init];
    signPromptLabel.backgroundColor = [UIColor clearColor];
    signPromptLabel.textColor = [UIColor colorWithHexString:@"333333"];
    signPromptLabel.font = [UIFont systemFontOfSize:14.f];
    signPromptLabel.text = @"签到成功提示语";
    [signPrmoptBgView addSubview:signPromptLabel];
    [signPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15.f);
        make.right.mas_equalTo(0);
    }];

    self.promptView = [[SAMTextView alloc]init];
    self.promptView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.promptView.font = [UIFont systemFontOfSize:14];
    self.promptView.textColor = [UIColor colorWithHexString:@"333333"];
    self.promptView.text = @"签到成功!";
    dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.promptView.typingAttributes = dic;
    self.promptView.textContainerInset = UIEdgeInsetsMake(20, 15, 20, 15);
    self.promptView.delegate = self;
    self.promptView.scrollEnabled = NO;
    [signPrmoptBgView addSubview:self.promptView];
    [self.promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(signPromptLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(-40);
    }];

    self.signInTypeContainerView = [[UIView alloc]init];
    self.signInTypeContainerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.signInTypeContainerView];
    [self.signInTypeContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(signPrmoptBgView.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    self.signTypeSelectView = [[SignInTypeSelectView alloc] init];
    [self.signInTypeContainerView addSubview:self.signTypeSelectView];
    [self.signTypeSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.signTypeSelectView.ChooseSignTypeBlock = ^{
        STRONG_SELF
        [self showSignSelectWithIsType:YES];
    };

    self.dynamicView = [[SignInSwitchView alloc]init];
    self.dynamicView.title = @"使用动态刷新的二维码";
    [self.signInTypeContainerView addSubview:self.dynamicView];
    [self.dynamicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.signTypeSelectView.mas_bottom).offset(1);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];

    self.signScopeSelectView = [[SignInScopeSelectView alloc] init];
    [self.signInTypeContainerView addSubview:self.signScopeSelectView];
    self.signScopeSelectView.ChooseSignScopeBlock = ^{
        STRONG_SELF
        if(self.groupSignInfo.count > 0){
            [self showSignSelectWithIsType:NO];
        }
    };

    self.locatonView = [[SignInLocationView alloc] init];
    [self.signInTypeContainerView addSubview:self.locatonView];
    self.locatonView.selectionBlock = ^{
        STRONG_SELF
        [self showSignInPlaceSelectionVCFromIndex:-1];
    };

    self.placeView = [[SignGroupPlaceView alloc] init];
    [self.signInTypeContainerView addSubview:self.placeView];
    self.placeView.changePlaceBlock = ^(NSInteger index) {
        STRONG_SELF
        [self showSignInPlaceSelectionVCFromIndex:index];
    };

    [self.signScopeSelectView setHidden:YES];
    [self.locatonView setHidden:YES];
    [self.placeView setHidden:YES];

}

- (void)refreshSubmitButton {
    if (self.titleView.text.length>0
        && self.promptView.text.length>0
        && self.dateView.content.length>0
        && self.begintimeView.content.length>0
        && self.endtimeView.content.length>0) {
        if (self.signTypeSelectView.signType == 1) {
            self.submitButton.enabled = YES;
        }else{
            if (self.signScopeSelectView.signScopeType == 1) {
                self.submitButton.enabled = !isEmpty(self.locatonView.locationStr);
            }else{
                self.submitButton.enabled = self.placeView.buttonEnabled;
            }
        }
    }else {
        self.submitButton.enabled = NO;
    }
}

- (void)refreshPlaceView{
    if (isEmpty(self.groupSignInfo)) {
        return ;
    }

    if (isEmpty(self.defaultSignInExts)){
        return ;
    }
    [self.groupSignInfo enumerateObjectsUsingBlock:^(GroupListRequest_Item_groups *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (SignInDetailRequest_Item_signInExts *signInExts in self.defaultSignInExts) {
            if ([signInExts.groupId isEqualToString:obj.groupsId]) {
                [self.placeView setDefaultDict:signInExts.toDictionary atIndex:idx];
                break;
            }
        }
    }];
}

#pragma mark - action
- (void)showSignSelectWithIsType:(BOOL)isType{
    [self.titleView resignFirstResponder];
    [self.promptView resignFirstResponder];
    FDActionSheetView *actionSheetView = [[FDActionSheetView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    actionSheetView.titleArray =  isType? @[@{@"title":@"扫码签到"}, @{@"title":@"位置签到"}] : @[@{@"title":@"全员签到"}, @{@"title":@"分组签到"}] ;
    self.alertView = [[AlertView alloc] init];
    self.alertView.backgroundColor = [UIColor clearColor];
    self.alertView.hideWhenMaskClicked = YES;
    self.alertView.contentView = actionSheetView;
    WEAK_SELF
    [self.alertView setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3 animations:^{
            [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left);
                make.right.equalTo(view.mas_right);
                make.top.equalTo(view.mas_bottom);
                make.height.mas_offset(155.0f);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [self.alertView showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.right.equalTo(view.mas_right);
            make.top.equalTo(view.mas_bottom);
            make.height.mas_offset(155.0f );
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left);
                    make.right.equalTo(view.mas_right);
                    if (@available(iOS 11.0, *)) {
                        make.bottom.mas_equalTo(view.mas_safeAreaLayoutGuideBottom);
                    } else {
                        make.bottom.mas_equalTo(0);
                    }
                    make.height.mas_offset(155.0f);
                }];
                [view layoutIfNeeded];
            } completion:^(BOOL finished) {

            }];
        });
    }];
    actionSheetView.actionSheetBlock = ^(NSInteger integer) {
        STRONG_SELF
        if (isType) {
            self.signTypeSelectView.signType = integer;
            if (integer == 1) {
                [self.signScopeSelectView setHidden:YES];
                [self.placeView setHidden:YES];
                [self.locatonView setHidden:YES];
                [self.dynamicView setHidden:NO];
                [self.dynamicView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(self.signTypeSelectView.mas_bottom).offset(1);
                    make.height.mas_equalTo(50);
                    make.bottom.mas_equalTo(0);
                }];
            }else if(integer == 2){
                [self.dynamicView setHidden:YES];
                [self.placeView setHidden:YES];
                [self.signScopeSelectView setHidden:NO];
                [self.dynamicView mas_remakeConstraints:^(MASConstraintMaker *make) {

                }];
                [self.signScopeSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(self.signTypeSelectView.mas_bottom).offset(1);
                    make.height.mas_equalTo(50);
                }];
                [self.locatonView setHidden:NO];
                [self.locatonView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(self.signScopeSelectView.mas_bottom).offset(1);
                    make.height.mas_equalTo(50);
                    make.bottom.mas_equalTo(0);
                }];
            }
        }else{
            self.signScopeSelectView.signScopeType = integer;
            if (integer == 1) {
                [self.placeView setHidden:YES];
                [self.signScopeSelectView setHidden:NO];
                [self.signScopeSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(self.signTypeSelectView.mas_bottom).offset(1);
                    make.height.mas_equalTo(50);
                }];
                [self.locatonView setHidden:NO];
                [self.locatonView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(self.signScopeSelectView.mas_bottom).offset(1);
                    make.height.mas_equalTo(50);
                    make.bottom.mas_equalTo(0);
                }];
            }else if(integer == 2){
                [self.locatonView setHidden:YES];
                [self.locatonView mas_remakeConstraints:^(MASConstraintMaker *make) {

                }];
                [self.placeView setHidden:NO];
                [self.signScopeSelectView setHidden:NO];
                [self.signScopeSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(self.signTypeSelectView.mas_bottom).offset(1);
                    make.height.mas_equalTo(50);
                }];
                [self.placeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(self.signScopeSelectView.mas_bottom).offset(1);
                    make.bottom.mas_equalTo(0);
                }];
            }
        }
        [self.view layoutSubviews];
        [self.alertView hide];
        [self refreshSubmitButton];
    };
}

- (void)showSelectionViewFrom:(SignInDateTimeView *)from {
    [self.titleView resignFirstResponder];
    [self.promptView resignFirstResponder];
    SignInDateTimeSettingView *settingView = [[SignInDateTimeSettingView alloc]init];
    if (from == self.dateView) {
        settingView.mode = UIDatePickerModeDate;
        settingView.date = self.signInDate;
    }else if (from == self.begintimeView){
        settingView.mode = UIDatePickerModeTime;
        settingView.date = self.beginTime;
    }else if (from == self.endtimeView) {
        settingView.mode = UIDatePickerModeTime;
        settingView.date = self.endTime;
    }
    WEAK_SELF
    [settingView setCancelBlock:^{
        STRONG_SELF
        [self.alertView hide];
    }];
    [settingView setConfirmBlock:^(NSString *result,NSDate *date){
        STRONG_SELF
        from.content = result;
        [self refreshSubmitButton];
        [self.alertView hide];
        if (from == self.dateView) {
            self.signInDate = date;
        }else if (from == self.begintimeView){
            self.beginTime = date;
        }else if (from == self.endtimeView) {
            self.endTime = date;
        }
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

- (void)showSignInPlaceSelectionVCFromIndex:(NSInteger)index {
    SignInPlaceViewController *vc = [[SignInPlaceViewController alloc]init];
    vc.nearbyPoi = self.selectedPoi;
    WEAK_SELF
    [vc setSelectBlock:^(BMKPoiInfo *info) {
        STRONG_SELF
        if (index == -1) {
            self.locatonView.locationStr = info.name;
            self.selectedPoi = info;
        }else{
            [self.placeView setBMKInfo:info atIndex:index];
        }
        [self refreshSubmitButton];
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
    self.createSignInRequest.signinType = [NSString stringWithFormat:@"%lu",(unsigned long)self.signTypeSelectView.signType];
    self.createSignInRequest.antiCheat = [NSString stringWithFormat:@"%@",@(YES)];
    self.createSignInRequest.startTime = start;
    self.createSignInRequest.endTime = end;
    self.createSignInRequest.signinType = [NSString stringWithFormat:@"%lu",(unsigned long)self.signTypeSelectView.signType];
    if (self.signTypeSelectView.signType == SignInType_Code) {
        self.createSignInRequest.qrcodeRefreshRate = [NSString stringWithFormat:@"%@",@(self.dynamicView.isOn)];
    }else{
        if (self.signScopeSelectView.signScopeType == SignInScopeType_Class) {
            self.createSignInRequest.signinPosition = [NSString stringWithFormat:@"%@,%@",@(self.selectedPoi.pt.longitude),@(self.selectedPoi.pt.latitude)];
            self.createSignInRequest.positionSite = self.selectedPoi.name;
        }else{
            self.createSignInRequest.signinExts = self.placeView.signInExts;
        }
    }
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
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[TaskViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }else if([vc isKindOfClass:[SignInListViewController class]]){
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
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

#pragma mark - request
- (void)requestGroupList{
    [self.grouplistRequest stopRequest];
    self.grouplistRequest = [[GroupListRequest alloc] init];
    self.grouplistRequest.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    WEAK_SELF
    [self.grouplistRequest startRequestWithRetClass:[GroupListRequest_Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self.placeView removeFromSuperview];
            return;
        }
        GroupListRequest_Item *item = (GroupListRequest_Item *)retItem;
        self.groupSignInfo = item.data.groups;
        if(item.data.groups.count == 0){
            [self.signScopeSelectView setCanSelect:NO];
            [self.placeView removeFromSuperview];
        }else {
            [self.signScopeSelectView setCanSelect:YES];
            [self.placeView setGroupsArray:item.data.groups];
        }
        [self refreshPlaceView];
    }];
}

- (void)requestDetail {
    [self.detailRequest stopRequest];
    self.detailRequest = [[SignInDetailRequest alloc]init];
    self.detailRequest.stepId = self.stepId;
    WEAK_SELF
    [self.detailRequest startRequestWithRetClass:[SignInDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            return;
        }
        SignInDetailRequestItem *item = (SignInDetailRequestItem *)retItem;
        [self.titleView setText:item.data.signIn.title];
        [self.promptView setText:item.data.signIn.successPrompt];
        NSArray *startArr = [item.data.signIn.startTime componentsSeparatedByString:@" "];
        [self.dateView setContent:[NSString stringWithFormat:@"%@",startArr.firstObject]];
        NSString *startTime = [startArr.lastObject substringToIndex:5];
        [self.begintimeView setContent:startTime];
        NSArray *endArr = [item.data.signIn.endTime componentsSeparatedByString:@" "];
        NSString *endTime = [endArr.lastObject substringToIndex:5];
        [self.endtimeView setContent:endTime];
        self.signTypeSelectView.signType = item.data.signIn.signinType.integerValue;
        self.signTypeSelectView.canSelect = NO;
        if ([item.data.signIn.signinType isEqualToString:@"1"]) {
            self.dynamicView.isOn = item.data.signIn.qrcodeRefreshRate.integerValue;
        }else{
            [self.dynamicView setHidden:YES];
            if (item.data.signIn.signinPosition.length > 0) {
                self.signScopeSelectView.signScopeType = SignInScopeType_Class;
                self.defaultSignInPosition = item.data.signIn.signinPosition;
                self.locatonView.locationStr = item.data.signIn.positionSite;
                [self.placeView setHidden:YES];
                [self.signScopeSelectView setHidden:NO];
                [self.dynamicView mas_remakeConstraints:^(MASConstraintMaker *make) {

                }];
                [self.signScopeSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(self.signTypeSelectView.mas_bottom).offset(1);
                    make.height.mas_equalTo(50);
                }];
                [self.locatonView setHidden:NO];
                [self.locatonView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(self.signScopeSelectView.mas_bottom).offset(1);
                    make.height.mas_equalTo(50);
                    make.bottom.mas_equalTo(0);
                }];

            }else{
                self.defaultSignInExts = item.data.signIn.signInExts;
                self.signScopeSelectView.signScopeType = SignInScopeType_Group;
                [self.locatonView setHidden:YES];
                [self.dynamicView mas_remakeConstraints:^(MASConstraintMaker *make) {

                }];
                [self.signScopeSelectView setHidden:NO];
                [self.signScopeSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(self.signTypeSelectView.mas_bottom).offset(1);
                    make.height.mas_equalTo(50);
                }];
                [self.placeView setHidden:NO];
                [self.placeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(self.signScopeSelectView.mas_bottom).offset(1);
                    make.bottom.mas_equalTo(0);
                }];
                [self refreshPlaceView];
            }
        }
        [self refreshSubmitButton];
    }];
}


- (void)updateSignInRequest{
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
    [self.updateRequest stopRequest];
    self.updateRequest = [[UpdateSignInRequest alloc] init];
    self.updateRequest.stepId = self.stepId;
    self.updateRequest.title = self.titleView.text;
    self.updateRequest.startTime = start;
    self.updateRequest.endTime = end;
    self.updateRequest.antiCheat = [NSString stringWithFormat:@"%@",@(YES)];
    if (self.signTypeSelectView.signType == SignInType_Code) {
        self.updateRequest.qrcodeRefreshRate = [NSString stringWithFormat:@"%@",@(self.dynamicView.isOn)];
    }else{
        if (self.signScopeSelectView.signScopeType == SignInScopeType_Class) {
            self.updateRequest.positionSite = self.locatonView.locationStr;
            if (self.selectedPoi) {
                self.updateRequest.signinPosition = [NSString stringWithFormat:@"%@,%@",@(self.selectedPoi.pt.longitude),@(self.selectedPoi.pt.latitude)];
            }else{
                self.updateRequest.signinPosition = self.defaultSignInPosition;
            }
        }else{
            self.updateRequest.signinExts = self.placeView.signInExts;
        }
    }
    self.updateRequest.successPrompt = self.promptView.text;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.updateRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
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

@end
