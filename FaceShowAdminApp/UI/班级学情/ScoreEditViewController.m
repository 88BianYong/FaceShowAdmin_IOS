//
//  ScoreEditViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScoreEditViewController.h"
#import "SetClazsScoreConfigRequest.h"
#import "GetClazsScoreConfigRequest.h"

@interface ScoreEditViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) SetClazsScoreConfigRequest *request;
@property (nonatomic, strong) NSString *jsconf;
@end

@implementation ScoreEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.currentItem.scoreName;
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    [self setupSaveButton];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(40);
    }];
    
    self.textfield = [[UITextField alloc]init];
    self.textfield.textColor = [UIColor colorWithHexString:@"333333"];
    self.textfield.returnKeyType = UIReturnKeyDone;
    self.textfield.font = [UIFont systemFontOfSize:14];
    self.textfield.keyboardType = UIKeyboardTypeNumberPad;
    self.textfield.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"积分" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textfield.delegate = self;
    [bottomView addSubview:self.textfield];
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-10);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.textfield.text = self.currentItem.scoreDefine;
    
    [[self.textfield rac_textSignal] subscribeNext:^(id x) {
        self.saveButton.enabled = !isEmpty(self.textfield.text);
    }];
}

- (void)setupSaveButton {
    self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [self.saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.enabled = NO;
    [self nyx_setupRightWithCustomView:self.saveButton];
}

- (void)saveAction {
    [self.textfield resignFirstResponder];
    self.currentItem.scoreDefine = self.textfield.text;
    [self.request stopRequest];
    self.request = [[SetClazsScoreConfigRequest alloc]init];
    self.request.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    self.request.jsconf = self.jsconf;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.request startRequestWithRetClass:[SetClazsScoreConfigRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self backAction];
        BLOCK_EXEC(self.finishBlock);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage] || [string includeEmoji]) {
        return NO;
    }
    return YES;
}

- (NSString *)jsconf {
    if (!_jsconf) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.data.configItems.count];
        [self.data.configItems enumerateObjectsUsingBlock:^(GetClazsScoreConfigRequestItem_configItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            if ([obj.scoreType isEqualToString:self.currentItem.scoreType]) {
                [dic setObject:self.currentItem.scoreType forKey:@"scoreType"];
                [dic setObject:self.currentItem.scoreDefine forKey:@"scoreDefine"];
            }else {
                [dic setObject:obj.scoreType forKey:@"scoreType"];
                [dic setObject:obj.scoreDefine forKey:@"scoreDefine"];
            }
            NSString *str = [dic JsonString];
            [array addObject:str];
        }];
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:&error];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        result = [result substringWithRange:NSMakeRange(2, [result length] - 4)];
        result = [NSString stringWithFormat:@"%@%@%@",@"[",result,@"]"];
        result = [result stringByReplacingOccurrencesOfString:@"\'"withString:@""];
        _jsconf = result;
    }
    return _jsconf;
}

@end
