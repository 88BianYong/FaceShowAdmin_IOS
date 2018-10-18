//
//  SignInSwitchView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInSwitchView.h"

@interface SignInSwitchView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *switchView;
@end

@implementation SignInSwitchView

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
    
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"二维码"];
    [self addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconView.mas_right).offset(4);
        make.centerY.mas_equalTo(0);
    }];
    
    self.switchView = [[UISwitch alloc]init];
    self.switchView.tintColor = [UIColor colorWithHexString:@"ebeff2"];
    self.switchView.onTintColor = [UIColor colorWithHexString:@"2379d2"];
    [self addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
}

- (BOOL)isOn{
    return self.switchView.isOn;
}

- (void)setIsOn:(BOOL)isOn{
    [self.switchView setOn:isOn animated:YES];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

@end
