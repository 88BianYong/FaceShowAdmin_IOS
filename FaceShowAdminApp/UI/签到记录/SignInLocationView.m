//
//  SignInLocationView.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/5/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignInLocationView.h"

@interface SignInLocationView()
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *changeButton;
@end

@implementation SignInLocationView

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
    
    self.totalLabel = [[UILabel alloc] init];
    [self.totalLabel setText:@"全体学员"];
    [self.totalLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.totalLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:self.totalLabel];
    CGSize size = [@"全体学员" sizeWithFont:[UIFont systemFontOfSize:14]];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(size);
    }];

    self.changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changeButton setTitle:@"修改位置" forState:UIControlStateNormal];
    [self.changeButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    self.changeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.changeButton.layer.cornerRadius = 12.5;
    self.changeButton.layer.masksToBounds = YES;
    self.changeButton.layer.borderColor = [UIColor colorWithHexString:@"0068bd"].CGColor;
    self.changeButton.layer.borderWidth = 1.0f;
    WEAK_SELF
    [[self.changeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.selectionBlock);
    }];
    [self addSubview:self.changeButton];
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.totalLabel);
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];

    self.locationLabel = [self.totalLabel clone];
    [self.locationLabel setText:@""];
    [self addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.changeButton.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-5);
    }];
}

- (void)btnAction {
    BLOCK_EXEC(self.selectionBlock);
}

- (void)setLocationStr:(NSString *)locationStr{
    _locationStr = locationStr;
    [self.locationLabel setText:locationStr];
}

@end

