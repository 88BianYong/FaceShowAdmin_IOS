//
//  AddMemberViewController.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "AddMemberViewController.h"
#import "AddMemberTextField.h"
#import "FDActionSheetView.h"
#import "AlertView.h"
#import "CreateMemberRequest.h"
#import "DetailWithAttachmentCellView.h"
#import "LoginUtils.h"

@interface AddMemberViewController ()
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) AddMemberTextField *nameTF;
@property (nonatomic, strong) DetailWithAttachmentCellView *sexCell;
@property (nonatomic, strong) AddMemberTextField *numberTF;
@property (nonatomic, strong) AddMemberTextField *schoolTF;

@property (nonatomic, strong) CreateMemberRequest *request;
@end

@implementation AddMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加成员";
    
    self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [self.saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.enabled = NO;
    [self nyx_setupRightWithCustomView:self.saveButton];
    
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    self.nameTF = [[AddMemberTextField alloc] init];
    self.nameTF.placeholder = @"姓名";
    [self.contentView addSubview:self.nameTF];
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(46);
    }];
    
    self.sexCell = [[DetailWithAttachmentCellView alloc] init];
    self.sexCell.placeholder = @"性别";
    WEAK_SELF
    self.sexCell.clickBlock = ^{
        STRONG_SELF
        [self.view endEditing:YES];
        [self showAlertView];
    };
    [self.contentView addSubview:self.sexCell];
    [self.sexCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.nameTF.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    
    self.numberTF = [[AddMemberTextField alloc] init];
    self.numberTF.placeholder = @"联系电话";
    self.numberTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:self.numberTF];
    [self.numberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.sexCell.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    
    self.schoolTF = [[AddMemberTextField alloc] init];
    self.schoolTF.placeholder = @"学校";
    self.schoolTF.needBottomLine = NO;
    [self.contentView addSubview:self.schoolTF];
    [self.schoolTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.numberTF.mas_bottom);
        make.height.mas_equalTo(46);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - setupObserver
- (void)setupObserver {
    WEAK_SELF
    [[self.nameTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshSaveBtn];
    }];
    [[self.numberTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshSaveBtn];
    }];
}

- (void)refreshSaveBtn {
    self.saveButton.enabled = !isEmpty(self.nameTF.text) && !isEmpty(self.numberTF.text);
}

#pragma mark - actions
- (void)showAlertView {
    FDActionSheetView *actionSheetView = [[FDActionSheetView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    actionSheetView.titleArray = @[@{@"title":@"男"},
                                   @{@"title":@"女"}];
    AlertView *alertView = [[AlertView alloc] init];
    alertView.backgroundColor = [UIColor clearColor];
    alertView.hideWhenMaskClicked = YES;
    alertView.contentView = actionSheetView;
    WEAK_SELF
    [alertView setHideBlock:^(AlertView *view) {
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
    [alertView showWithLayout:^(AlertView *view) {
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
                    make.bottom.equalTo(view.mas_bottom);
                    make.height.mas_offset(155.0f);
                }];
                [view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        });
    }];
    actionSheetView.actionSheetBlock = ^(NSInteger integer) {
        STRONG_SELF
        if (integer == 1) {
            self.sexCell.title = @"男";
        } else if (integer == 2) {
            self.sexCell.title = @"女";
        }
        [alertView hide];
    };
}

- (void)saveAction {
    if (![LoginUtils isPhoneNumberValid:self.numberTF.text]) {
        [self.view nyx_showToast:@"请输入正确的手机号码"];
        return;
    }
    [self.request stopRequest];
    self.request = [[CreateMemberRequest alloc] init];
    self.request.realName = [self.nameTF.text yx_stringByTrimmingCharacters];
    self.request.mobilePhone = self.numberTF.text;
    if (!isEmpty(self.sexCell.title)) {
        self.request.sex = [self.sexCell.title isEqualToString:@"男"] ? @"1" : @"0";
    }
    self.request.schoolName = self.schoolTF.text;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        BLOCK_EXEC(self.saveSucceedBlock);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
