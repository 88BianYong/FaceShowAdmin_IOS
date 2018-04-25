//
//  VerifyCodeInputView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "VerifyCodeInputView.h"
#import "LoginInputView.h"
#import "YXGCDTimer.h"

static const NSInteger kTimerDuration = 60;

@interface VerifyCodeInputView()<UITextFieldDelegate>

@property (nonatomic, strong) LoginInputView *inputView;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) YXGCDTimer *timer;
@property (nonatomic, assign) NSInteger secondsRemained;
@end

@implementation VerifyCodeInputView

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
    self.codeButton = [[UIButton alloc]init];
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.codeButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.codeButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(103);
    }];
    UIView *seperatorView = [[UIView alloc]init];
    seperatorView.backgroundColor = [UIColor colorWithHexString:@"dce0e3"];
    [self addSubview:seperatorView];
    [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.codeButton.mas_left);
        make.size.mas_equalTo(CGSizeMake(1, 18));
        make.centerY.mas_equalTo(0);
    }];
    self.inputView = [[LoginInputView alloc]init];
    self.inputView.textField.textColor = [UIColor colorWithHexString:@"333333"];
    self.inputView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.inputView.textField.delegate = self;
    self.inputView.textField.font = [UIFont fontWithName:YXFontMetro_Regular size:19];
    self.inputView.textField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"输入短信验证码" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(seperatorView.mas_left).mas_offset(-15);
    }];
    
}

- (void)setupObserver {
    WEAK_SELF
    [[self.inputView.textField rac_textSignal]subscribeNext:^(NSString *text) {
        STRONG_SELF
        if (text.length>6) {
            self.inputView.textField.text = [text substringToIndex:6];
        }
        BLOCK_EXEC(self.textChangeBlock)
    }];
}

- (void)btnAction {
    if (self.secondsRemained > 0) {
        return;
    }
    BLOCK_EXEC(self.sendAction);
}

- (void)setIsActive:(BOOL)isActive {
    _isActive = isActive;
    if (self.secondsRemained > 0) {
        return;
    }
    if (isActive) {
        self.codeButton.enabled = YES;
    }else {
        self.codeButton.enabled = NO;
    }
}

- (NSString *)text {
    return [self.inputView.textField.text yx_stringByTrimmingCharacters];
}

#pragma mark - timer
- (void)startTimer {
    if (!self.timer) {
        self.secondsRemained = kTimerDuration;
        WEAK_SELF
        self.timer = [[YXGCDTimer alloc]initWithInterval:1 repeats:YES triggerBlock:^{
            STRONG_SELF
            [self countdownTimer];
        }];
        [self.timer resume];
    }
    [self.codeButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    self.codeButton.titleLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:19];
}

- (void)countdownTimer {
    if (self.secondsRemained <= 0) {
        [self stopTimer];
    } else {
        self.secondsRemained--;
        NSString *title = [NSString stringWithFormat:@"%@",@(self.secondsRemained)];
        [self.codeButton setTitle:title forState:UIControlStateNormal];
    }
    [self setIsActive:self.secondsRemained <= 0];
}

- (void)stopTimer {
    self.timer = nil;
    self.secondsRemained = 0;
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self setIsActive:self.secondsRemained <= 0];
    [self.codeButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.codeButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (isEmpty(string) || [string nyx_isPureInt]) {
        return YES;
    }
    return NO;
}
@end
