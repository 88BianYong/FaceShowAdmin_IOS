//
//  UpdateTextInfoViewController.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UpdateTextInfoViewController.h"
#import "UpdateUserInfoRequest.h"

@interface UpdateTextInfoViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UpdateUserInfoRequest *request;
@end

@implementation UpdateTextInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"编辑%@", self.type ? @"学校" : @"姓名"];

    self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [self.saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.enabled = NO;
    [self nyx_setupRightWithCustomView:self.saveButton];
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.clipsToBounds = YES;
    bottomView.layer.cornerRadius = 6;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(40);
    }];
    
    self.textfield = [[UITextField alloc]init];
    self.textfield.textColor = [UIColor colorWithHexString:@"333333"];
    self.textfield.returnKeyType = UIReturnKeyDone;
    self.textfield.font = [UIFont systemFontOfSize:14];
    self.textfield.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:self.type ? @"学校" : @"姓名" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textfield.delegate = self;
    [bottomView addSubview:self.textfield];
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.textfield.text = self.type ? [UserManager sharedInstance].userModel.school : [UserManager sharedInstance].userModel.realName;
    
    [[self.textfield rac_textSignal] subscribeNext:^(id x) {
        self.saveButton.enabled = !isEmpty(self.textfield.text);
    }];
}

- (void)saveAction {
    [self.textfield resignFirstResponder];
    [self.request stopRequest];
    self.request = [[UpdateUserInfoRequest alloc]init];
    if (self.type) {
        self.request.school = self.textfield.text;
    } else {
        self.request.realName = self.textfield.text;
    }
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        if (self.type) {
            [UserManager sharedInstance].userModel.school = self.textfield.text;
        } else {
            [UserManager sharedInstance].userModel.realName = self.textfield.text;
        }
        [[UserManager sharedInstance]saveData];
        BLOCK_EXEC(self.updateTextInfoSucceedBlock);
        [self backAction];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpdateUserInfoSucceedNotification" object:nil];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
