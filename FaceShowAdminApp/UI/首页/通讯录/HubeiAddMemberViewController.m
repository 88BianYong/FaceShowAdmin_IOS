//
//  HubeiAddMemberViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HubeiAddMemberViewController.h"
#import "AddMemberTextField.h"
#import "FDActionSheetView.h"
#import "AlertView.h"
#import "CreateUserRequest.h"
#import "DetailWithAttachmentCellView.h"
#import "LoginUtils.h"
#import "HubeiStageSelectionViewController.h"
#import "HubeiSubjectSelectionViewController.h"
#import "HubeiDistrictSelectionViewController.h"
#import "HubeiProvinceSelectionViewController.h"

@interface HubeiAddMemberViewController ()
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) AddMemberTextField *nameTF;
@property (nonatomic, strong) DetailWithAttachmentCellView *sexCell;
@property (nonatomic, strong) AddMemberTextField *numberTF;
@property (nonatomic, strong) AddMemberTextField *schoolTF;
@property (nonatomic, strong) DetailWithAttachmentCellView *stageSubjectCell;
@property (nonatomic, strong) DetailWithAttachmentCellView *provinceCell;
@property (nonatomic, strong) AddMemberTextField *idCardTF;
@property (nonatomic, strong) AddMemberTextField *areaTF;
@property (nonatomic, strong) AddMemberTextField *schoolTypeTF;
@property (nonatomic, strong) AddMemberTextField *nationTF;
@property (nonatomic, strong) AddMemberTextField *titleTF;
@property (nonatomic, strong) AddMemberTextField *educationTF;
@property (nonatomic, strong) AddMemberTextField *graduationTF;
@property (nonatomic, strong) AddMemberTextField *professionalTF;

@property (nonatomic, strong) CreateUserRequest *request;

@property (nonatomic, strong) Stage *stage;
@property (nonatomic, strong) Subject *subject;
@property (nonatomic, strong) Area *province;
@property (nonatomic, strong) Area *city;
@property (nonatomic, strong) Area *district;
@end

@implementation HubeiAddMemberViewController

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
    //姓名-联系电话-性别-学段-学科-省市区-学校-身份证号-学校所在区域-学校类别-民族-职称-最高学历-毕业院校-所学专业
    self.nameTF = [[AddMemberTextField alloc] init];
    self.nameTF.placeholder = @"姓名";
    [self.contentView addSubview:self.nameTF];
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(46);
    }];
    self.numberTF = [[AddMemberTextField alloc] init];
    self.numberTF.placeholder = @"联系电话";
    self.numberTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:self.numberTF];
    [self.numberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.nameTF.mas_bottom);
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
        make.top.mas_equalTo(self.numberTF.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    self.stageSubjectCell = [[DetailWithAttachmentCellView alloc] init];
    self.stageSubjectCell.placeholder = @"学段学科";
    self.stageSubjectCell.clickBlock = ^{
        STRONG_SELF
        [self.view endEditing:YES];
        HubeiStageSelectionViewController *vc = [[HubeiStageSelectionViewController alloc]init];
        vc.currentStage = self.stage;
        vc.currentSubject = self.subject;
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.contentView addSubview:self.stageSubjectCell];
    [self.stageSubjectCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.sexCell.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    self.provinceCell = [[DetailWithAttachmentCellView alloc] init];
    self.provinceCell.placeholder = @"省市区";
    self.provinceCell.clickBlock = ^{
        STRONG_SELF
        [self.view endEditing:YES];
        HubeiProvinceSelectionViewController *vc = [[HubeiProvinceSelectionViewController alloc]init];
        vc.currentProvince = self.province;
        vc.currentCity = self.city;
        vc.currentDistrict = self.district;
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.contentView addSubview:self.provinceCell];
    [self.provinceCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.stageSubjectCell.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    self.schoolTF = [[AddMemberTextField alloc] init];
    self.schoolTF.placeholder = @"学校";
    [self.contentView addSubview:self.schoolTF];
    [self.schoolTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.provinceCell.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    self.idCardTF = [[AddMemberTextField alloc] init];
    self.idCardTF.placeholder = @"身份证号";
    self.idCardTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:self.idCardTF];
    [self.idCardTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.schoolTF.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    self.areaTF = [[AddMemberTextField alloc] init];
    self.areaTF.placeholder = @"学校所在区域";
    [self.contentView addSubview:self.areaTF];
    [self.areaTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.idCardTF.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    self.schoolTypeTF = [[AddMemberTextField alloc] init];
    self.schoolTypeTF.placeholder = @"学校类别";
    [self.contentView addSubview:self.schoolTypeTF];
    [self.schoolTypeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.areaTF.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    self.nationTF = [[AddMemberTextField alloc] init];
    self.nationTF.placeholder = @"民族";
    [self.contentView addSubview:self.nationTF];
    [self.nationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.schoolTypeTF.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    self.titleTF = [[AddMemberTextField alloc] init];
    self.titleTF.placeholder = @"职称";
    [self.contentView addSubview:self.titleTF];
    [self.titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.nationTF.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    self.educationTF = [[AddMemberTextField alloc] init];
    self.educationTF.placeholder = @"最高学历";
    [self.contentView addSubview:self.educationTF];
    [self.educationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleTF.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    self.graduationTF = [[AddMemberTextField alloc] init];
    self.graduationTF.placeholder = @"毕业院校";
    [self.contentView addSubview:self.graduationTF];
    [self.graduationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.educationTF.mas_bottom);
        make.height.mas_equalTo(46);
    }];
    self.professionalTF = [[AddMemberTextField alloc] init];
    self.professionalTF.placeholder = @"所学专业";
    self.professionalTF.needBottomLine = NO;
    [self.contentView addSubview:self.professionalTF];
    [self.professionalTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.graduationTF.mas_bottom);
        make.height.mas_equalTo(46);
        make.bottom.mas_equalTo(-5);
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
    [[self.schoolTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshSaveBtn];
    }];
    [[self.idCardTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshSaveBtn];
    }];
    [[self.areaTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshSaveBtn];
    }];
    [[self.schoolTypeTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshSaveBtn];
    }];
    [[self.nationTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshSaveBtn];
    }];
    [[self.titleTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshSaveBtn];
    }];
    [[self.educationTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshSaveBtn];
    }];
    [[self.graduationTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshSaveBtn];
    }];
    [[self.professionalTF rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshSaveBtn];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kStageSubjectDidSelectNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = x;
        self.stage = [noti.userInfo valueForKey:kStageItemKey];
        self.subject = [noti.userInfo valueForKey:kSubjectItemKey];
        self.stageSubjectCell.title = [NSString stringWithFormat:@"%@-%@",self.stage.name,self.subject.name];
        [self refreshSaveBtn];
        [self.navigationController popToViewController:self animated:YES];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kAreaDidSelectNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = x;
        self.province = [noti.userInfo valueForKey:kProvinceItemKey];
        self.city = [noti.userInfo valueForKey:kCityItemKey];
        self.district = [noti.userInfo valueForKey:kDistrictItemKey];
        self.provinceCell.title = [NSString stringWithFormat:@"%@-%@-%@",self.province.name,self.city.name,self.district.name];
        [self refreshSaveBtn];
        [self.navigationController popToViewController:self animated:YES];
    }];
}

- (void)refreshSaveBtn {
    self.saveButton.enabled = !isEmpty(self.nameTF.text) &&
                              !isEmpty(self.numberTF.text) &&
                              !isEmpty(self.schoolTF.text) &&
                              !isEmpty(self.idCardTF.text) &&
                              !isEmpty(self.areaTF.text) &&
                              !isEmpty(self.schoolTypeTF.text) &&
                              !isEmpty(self.nationTF.text) &&
                              !isEmpty(self.titleTF.text) &&
                              !isEmpty(self.educationTF.text) &&
                              !isEmpty(self.graduationTF.text) &&
                              !isEmpty(self.professionalTF.text) &&
                              !isEmpty(self.sexCell.title) &&
                              !isEmpty(self.stageSubjectCell.title) &&
                              !isEmpty(self.provinceCell.title);
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
        [self refreshSaveBtn];
        [alertView hide];
    };
}

- (void)saveAction {
    if (![LoginUtils isPhoneNumberValid:self.numberTF.text]) {
        [self.view nyx_showToast:@"请输入正确的手机号码"];
        return;
    }
    [self.request stopRequest];
    self.request = [[CreateUserRequest alloc] init];
    self.request.realName = [self.nameTF.text yx_stringByTrimmingCharacters];
    self.request.mobilePhone = self.numberTF.text;
    self.request.sex = [self.sexCell.title isEqualToString:@"男"] ? @"1" : @"0";
    self.request.school = self.schoolTF.text;
    self.request.stage = self.stage.stageID;
    self.request.subject = self.subject.subjectID;
    self.request.province = self.province.areaID;
    self.request.city = self.city.areaID;
    self.request.country = self.district.areaID;
    self.request.idCard = self.idCardTF.text;
    self.request.area = self.areaTF.text;
    self.request.schoolType = self.schoolTypeTF.text;
    self.request.nation = self.nationTF.text;
    self.request.title = self.titleTF.text;
    self.request.recordeducation = self.educationTF.text;
    self.request.graduation = self.graduationTF.text;
    self.request.professional = self.professionalTF.text;
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
