//
//  SignInScopeSelectView.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignInScopeSelectView.h"

@interface SignInScopeSelectView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *signTypeButton;
@property (nonatomic, strong) UIButton *downButton;

@end

@implementation SignInScopeSelectView


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
    self.titleLabel.text = @"签到类型";
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
        BLOCK_EXEC(self.ChooseSignScopeBlock);
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
        BLOCK_EXEC(self.ChooseSignScopeBlock);
    }];
    self.signScopeType = SignInScopeType_Class;
}

- (void)setSignScopeType:(SignInScopeType)signScopeType{
    _signScopeType = signScopeType;
    switch (signScopeType) {
        case SignInScopeType_Class:
        {
            [self.signTypeButton setTitle:@"全员签到" forState:UIControlStateNormal];
            [self.signTypeButton setImage:[UIImage imageNamed:@"全员签到"] forState:UIControlStateNormal];
        }
            break;
        case SignInScopeType_Group:
        {
            [self.signTypeButton setTitle:@"分组签到" forState:UIControlStateNormal];
            [self.signTypeButton setImage:[UIImage imageNamed:@"分组签到"] forState:UIControlStateNormal];
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
