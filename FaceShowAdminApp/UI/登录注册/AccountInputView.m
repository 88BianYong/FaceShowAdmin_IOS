//
//  AccountInputView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "AccountInputView.h"
#import "UIButton+ExpandHitArea.h"

@interface AccountInputView()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *clearButton;
@end

@implementation AccountInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.layer.cornerRadius = 6;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 2;
//    self.backgroundColor = [UIColor colorWithHexString:@"69ad0a"];
    self.clearButton = [[UIButton alloc]init];
    [self.clearButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"删除当前编辑文字icon正常态"] forState:UIControlStateNormal];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"删除当前编辑文字icon点击态"] forState:UIControlStateHighlighted];
    [self.clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clearButton];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-7);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    self.inputView = [[LoginInputView alloc]init];
    self.inputView.placeHolder = @"请输入账号";
    self.inputView.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.inputView.textField.delegate = self;
    [self addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-5);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.clearButton.backgroundColor = [UIColor redColor];
}

- (void)setupObserver {
    WEAK_SELF
    [[self.inputView.textField rac_textSignal]subscribeNext:^(id x) {
        STRONG_SELF
        self.clearButton.hidden = isEmpty(x);
        BLOCK_EXEC(self.textChangeBlock)
    }];
}

- (void)clearAction {
    self.inputView.textField.text = @"";
    BLOCK_EXEC(self.textChangeBlock)
    self.clearButton.hidden = YES;
}

- (NSString *)text {
    return [self.inputView.textField.text yx_stringByTrimmingCharacters];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.clearButton.hidden = textField.text.length==0;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.clearButton.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField.keyboardType != UIKeyboardTypeNumberPad) {
//        return YES;
//    }
//    if (isEmpty(string) || [string nyx_isPureInt]) {
//        return YES;
//    }
//    return NO;
//}

@end
