//
//  SignInTypeView.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/5/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignInTypeView.h"

@interface SignInTypeView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, copy) ChooseSignTypeBlock block;
@end

@implementation SignInTypeView

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
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.iconButton setImage:[UIImage imageNamed:@"未点击"] forState:UIControlStateNormal];
    [self.iconButton setImage:[UIImage imageNamed:@"点击"] forState:UIControlStateSelected];
    [self addSubview:self.iconButton];
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UIButton *contentButton = [[UIButton alloc]init];
     WEAK_SELF
    [[contentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.iconButton.isSelected) {
            return;
        }
        self.iconButton.selected = YES;
        BLOCK_EXEC(self.block);
    }];
    [self addSubview:contentButton];
    [contentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (BOOL)isSelected {
    return self.iconButton.isSelected;
}

- (void)setIsSelected:(BOOL)isSelected {
    self.iconButton.selected = isSelected;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setChooseSignTypeBlock:(ChooseSignTypeBlock)block {
    self.block = block;
}
@end

