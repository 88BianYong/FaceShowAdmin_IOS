//
//  PasswordResetView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PasswordResetView.h"

@interface PasswordResetView()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *showHideButton;
@end

@implementation PasswordResetView

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
    self.showHideButton = [[UIButton alloc]init];
    [self.showHideButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    [self.showHideButton setBackgroundImage:[UIImage imageNamed:@"隐藏密码2正常态"] forState:UIControlStateNormal];
    [self.showHideButton setBackgroundImage:[UIImage imageNamed:@"隐藏密码2点击态"] forState:UIControlStateHighlighted];
    [self.showHideButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.showHideButton];
    [self.showHideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-7);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.inputView = [[LoginInputView alloc]init];
    self.inputView.textField.delegate = self;
    self.inputView.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.inputView.textField.secureTextEntry = YES;
    self.inputView.textField.clearsOnBeginEditing = NO;
    self.inputView.textField.textColor = [UIColor colorWithHexString:@"333333"];
    self.inputView.textField.font = [UIFont fontWithName:YXFontMetro_Regular size:19];
    self.inputView.textField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"输入6-20位新密码" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.showHideButton.mas_left).mas_offset(-5);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[self.inputView.textField rac_textSignal]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.textChangeBlock)
    }];
}

- (void)btnAction {
    self.inputView.textField.secureTextEntry = !self.inputView.textField.secureTextEntry;
    if (self.inputView.textField.secureTextEntry) {
        [self.showHideButton setBackgroundImage:[UIImage imageNamed:@"隐藏密码2正常态"] forState:UIControlStateNormal];
        [self.showHideButton setBackgroundImage:[UIImage imageNamed:@"隐藏密码2点击态"] forState:UIControlStateHighlighted];
    }else {
        [self.showHideButton setBackgroundImage:[UIImage imageNamed:@"显示密码2正常态"] forState:UIControlStateNormal];
        [self.showHideButton setBackgroundImage:[UIImage imageNamed:@"显示密码2点击态"] forState:UIControlStateHighlighted];
    }
}

- (NSString *)text {
    return [self.inputView.textField.text yx_stringByTrimmingCharacters];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //Setting the new text.
    NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = updatedString;
    
    //Setting the cursor at the right place
    NSRange selectedRange = NSMakeRange(range.location + string.length, 0);
    UITextPosition* from = [textField positionFromPosition:textField.beginningOfDocument offset:selectedRange.location];
    UITextPosition* to = [textField positionFromPosition:from offset:selectedRange.length];
    textField.selectedTextRange = [textField textRangeFromPosition:from toPosition:to];
    
    //Sending an action
    [textField sendActionsForControlEvents:UIControlEventEditingChanged];
    
    return NO;
}

@end
