//
//  SignInTypeSelectView.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignInTypeSelectView.h"

@interface SignInTypeSelectView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *signTypeButton;
@property (nonatomic, strong) UIButton *downButton;

@end

@implementation SignInTypeSelectView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = @"签到方式";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];

    UIButton *down = [UIButton buttonWithType:UIButtonTypeCustom];
    [down setImage:[UIImage imageNamed:@"下拉按钮正常态"] forState:UIControlStateNormal];
    [down setImage:[UIImage imageNamed:@"下拉按钮点击态"] forState:UIControlStateSelected];
    [self addSubview:down];
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    WEAK_SELF
    [[down rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.ChooseSignTypeBlock);
    }];
    self.downButton = down;

    self.signTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.signTypeButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.signTypeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:self.signTypeButton];
    [self.signTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(down.mas_left).offset(-15);
        make.centerY.mas_equalTo(0);
    }];
    [[self.signTypeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.ChooseSignTypeBlock);
    }];
    self.signType = SignInType_Code;
}

- (void)setSignType:(SignInType)signType{
    _signType = signType;
    switch (signType) {
        case SignInType_Code:
        {
            [self.signTypeButton setTitle:@"扫码签到" forState:UIControlStateNormal];
            [self.signTypeButton setImage:[UIImage imageNamed:@"二维码"] forState:UIControlStateNormal];
        }
            break;
        case SignInType_Location:
        {
            [self.signTypeButton setTitle:@"位置签到" forState:UIControlStateNormal];
            [self.signTypeButton setImage:[UIImage imageNamed:@"位置"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)setCanSelect:(BOOL)canSelect{
    _canSelect = canSelect;
    [self.downButton setEnabled:canSelect];
    [self.signTypeButton setEnabled:canSelect];
}

@end
