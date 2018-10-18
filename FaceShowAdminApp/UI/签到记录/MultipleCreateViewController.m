//
//  MultipleCreateViewController.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MultipleCreateViewController.h"
#import "SignInDateTimeView.h"
#import "SignInTypeView.h"
#import "SignInSwitchView.h"
#import "SignInLocationView.h"
#import "SignGroupPlaceView.h"
#import "SignInDateTimeSettingView.h"
#import "AlertView.h"
#import "MultipleSignDateSelectView.h"
#import "MultipleSignDateView.h"
#import "SignDateSelectTypeMode.h"
#import "SignInPlaceViewController.h"
#import "GroupListRequest.h"
#import "BatchCreateSignInsRequest.h"
#import "SignInTypeSelectView.h"
#import "SignInScopeSelectView.h"
#import "FDActionSheetView.h"
#import "SignInListViewController.h"
#import "TaskViewController.h"

@interface MultipleCreateViewController ()<UITextViewDelegate>

@property (nonatomic, strong) MultipleSignDateView *dateView;
@property (nonatomic, strong) SAMTextView *promptView;
@property (nonatomic, strong) UIView *signInTypeContainerView;
@property (nonatomic, strong) SignInTypeSelectView *signTypeSelectView;
@property (nonatomic, strong) SignInScopeSelectView *signScopeSelectView;
@property (nonatomic, strong) SignInSwitchView *dynamicView;
@property (nonatomic, strong) SignInLocationView *locatonView;
@property (nonatomic, strong) SignGroupPlaceView *placeView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) BMKPoiInfo *selectedPoi;
@property (nonatomic, strong) GroupListRequest *grouplistRequest;
@property (nonatomic, strong) BatchCreateSignInsRequest *branchCreateRequest;
@property (nonatomic, copy) NSArray *groupSignInfo;
@end

@implementation MultipleCreateViewController

- (void)dealloc{
    DDLogDebug(@"%@ -- dealloc",NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"批量签到";
    self.submitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [self.submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.enabled = NO;
    [self nyx_setupRightWithCustomView:self.submitButton];
    [self setupUI];
    [self requestGroupList];
}


- (void)setupUI{
    
    WEAK_SELF
    self.dateView = [[MultipleSignDateView alloc] init];
    [self.contentView addSubview:self.dateView];
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
    }];
    NSString *clazsStart = [UserManager sharedInstance].userModel.currentClass.startTime;
    NSString *clazsEnd = [UserManager sharedInstance].userModel.currentClass.endTime;
    NSString *start = [clazsStart componentsSeparatedByString:@" "].firstObject;
    NSString *end = [clazsEnd componentsSeparatedByString:@" "].firstObject;
    if(_isDefault){
        [self.dateView setDefaultStartDate:start endDate:end];
        self.submitButton.enabled = YES;
    }
    self.dateView.dateSelectBlock = ^(MultipleSignDateSelectView *selectView, NSInteger row) {
        STRONG_SELF
        [self showSelectionViewFromSelectView:selectView Row:row];
    };

    UIView *signPrmoptBgView = [[UIView alloc]init];
    signPrmoptBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:signPrmoptBgView];
    [signPrmoptBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.dateView.mas_bottom).offset(5);
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
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]};
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

#pragma mark - action
- (void)showSignSelectWithIsType:(BOOL)isType{
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


- (void)showSelectionViewFromSelectView:(MultipleSignDateSelectView *)selectView Row:(NSInteger)row{
    [self.promptView resignFirstResponder];
    SignInDateTimeSettingView *settingView = [[SignInDateTimeSettingView alloc]init];
    switch (selectView.type) {
        case SignDateSelectTypeMode_Date:
            settingView.mode = UIDatePickerModeDate;
            break;
        case SignDateSelectTypeMode_Time:
            settingView.mode = UIDatePickerModeTime;
            break;
        default:
            break;
    }
    WEAK_SELF
    [settingView setCancelBlock:^{
        STRONG_SELF
        [self.alertView hide];
    }];
    [settingView setConfirmBlock:^(NSString *result,NSDate *date){
        STRONG_SELF
        [self.alertView hide];
        [selectView setSelectDate:result atRow:row];
        [self refreshSubmitButton];
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

    NSString *error;
    error = [self.dateView canBeSubmitted];
    if (error) {
        [self.view nyx_showToast:error];
        return;
    }

    [self.branchCreateRequest stopRequest];
    self.branchCreateRequest = [[BatchCreateSignInsRequest alloc] init];
    self.branchCreateRequest.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    self.branchCreateRequest.signInTimeSetting = [NSString stringWithFormat:@"%@",self.dateView.signInTimeSetting];
    self.branchCreateRequest.successPrompt = self.promptView.text;
    self.branchCreateRequest.signinType = [NSString stringWithFormat:@"%lu",(unsigned long)self.signTypeSelectView.signType];
    self.branchCreateRequest.antiCheat = [NSString stringWithFormat:@"%@",@(YES)];
    if (self.signTypeSelectView.signType == SignInType_Code) {
        self.branchCreateRequest.qrcodeRefreshRate = [NSString stringWithFormat:@"%@",@(self.dynamicView.isOn)];
    }else{
        if (self.signScopeSelectView.signScopeType == SignInScopeType_Class) {
            self.branchCreateRequest.signinPosition = [NSString stringWithFormat:@"%@,%@",@(self.selectedPoi.pt.longitude),@(self.selectedPoi.pt.latitude)];
            self.branchCreateRequest.positionSite = self.selectedPoi.name;
        }else{
            self.branchCreateRequest.signinExts = [NSString stringWithFormat:@"%@",self.placeView.signInExts];
        }
    }
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.branchCreateRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
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


- (void)refreshSubmitButton {
    if(self.promptView.text.length > 0 && self.dateView.buttonEnabled){
        if (self.signTypeSelectView.signType == SignInType_Code) {
            self.submitButton.enabled = YES;
        }else{
            if(self.signScopeSelectView.signScopeType == SignInScopeType_Class){
                self.submitButton.enabled = !isEmpty(self.locatonView.locationStr);
            }else{
                self.submitButton.enabled = self.placeView.buttonEnabled;
            }
        }
    }else {
        self.submitButton.enabled = NO;
    }
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

#pragma mark  - request
- (void)requestGroupList{
    [self.grouplistRequest stopRequest];
    self.grouplistRequest = [[GroupListRequest alloc] init];
    self.grouplistRequest.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    WEAK_SELF
    [self.grouplistRequest startRequestWithRetClass:[GroupListRequest_Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            return;
        }
        GroupListRequest_Item *item = (GroupListRequest_Item *)retItem;
        self.groupSignInfo = item.data.groups;
        if(item.data.groups.count == 0){
            [self.signScopeSelectView setCanSelect:NO];
            [self.placeView removeFromSuperview];
        }else{
            [self.signScopeSelectView setCanSelect:YES];
            [self.placeView setGroupsArray:item.data.groups];
        }
    }];
}

- (void)batchCreateSignInsRequest{
    [self.branchCreateRequest stopRequest];
    self.branchCreateRequest = [[BatchCreateSignInsRequest alloc] init];
    self.branchCreateRequest.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    self.branchCreateRequest.signInTimeSetting = [NSString stringWithFormat:@"%@",self.dateView.signInTimeSetting];
    self.branchCreateRequest.antiCheat = [NSString stringWithFormat:@"%@",@(YES)];
    self.branchCreateRequest.successPrompt = self.promptView.text;
    if(self.signTypeSelectView.signType == SignInType_Code){
        self.branchCreateRequest.signinType = @"1";
        self.branchCreateRequest.qrcodeRefreshRate = [NSString stringWithFormat:@"%@",@(self.dynamicView.isOn)];
    }else{
        if (self.signScopeSelectView.signScopeType == SignInScopeType_Class) {
            self.branchCreateRequest.signinPosition = [NSString stringWithFormat:@"%@,%@",@(self.selectedPoi.pt.longitude),@(self.selectedPoi.pt.latitude)];
            self.branchCreateRequest.positionSite = self.locatonView.locationStr;
        }else{
            self.branchCreateRequest.signinExts = [NSString stringWithFormat:@"%@",self.placeView.signInExts];
        }
    }
    WEAK_SELF
    [self.branchCreateRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
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
