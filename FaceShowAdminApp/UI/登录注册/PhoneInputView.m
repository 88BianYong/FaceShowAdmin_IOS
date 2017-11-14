//
//  PhoneInputView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PhoneInputView.h"

@interface PhoneInputView()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *clearButton;
@end

@implementation PhoneInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.layer.cornerRadius = 6;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.clearButton = [[UIButton alloc]init];
    [self.clearButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"删除按钮2正常态"] forState:UIControlStateNormal];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"删除按钮2点击态"] forState:UIControlStateHighlighted];
    [self.clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clearButton];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-7);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.inputView = [[LoginInputView alloc]init];
    self.inputView.textField.font = [UIFont fontWithName:YXFontMetro_Regular size:19];
    self.inputView.textField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"输入手机号" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
    self.inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.inputView.textField.textColor = [UIColor colorWithHexString:@"333333"];
    self.inputView.textField.delegate = self;
    [self addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-5);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[self.inputView.textField rac_textSignal]subscribeNext:^(NSString *x) {
        STRONG_SELF
        self.clearButton.hidden = isEmpty(x);
        if (x.length>11) {
            self.inputView.textField.text = [x substringToIndex:11];
        }
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
