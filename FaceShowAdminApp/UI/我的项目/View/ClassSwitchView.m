//
//  ClassSwitchView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassSwitchView.h"

@interface ClassSwitchView()
@property (nonatomic, strong) UIButton *preButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *classNameLabel;
@end

@implementation ClassSwitchView

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
    self.preButton = [[UIButton alloc]init];
    [self.preButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [self.preButton addTarget:self action:@selector(preAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.preButton];
    [self.preButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(0);
    }];
    self.nextButton = [[UIButton alloc]init];
    [self.nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(0);
    }];
    self.classNameLabel = [[UILabel alloc]init];
    self.classNameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.classNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.classNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.classNameLabel];
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.preButton.mas_right).mas_offset(10);
        make.right.mas_equalTo(self.nextButton.mas_left).mas_offset(-10);
        make.top.mas_equalTo(12);
    }];
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.font = [UIFont systemFontOfSize:12];
    promptLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.text = @"左右滑动切换班级";
    [self addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.classNameLabel.mas_bottom).mas_offset(6);
    }];
}

- (void)preAction {
    BLOCK_EXEC(self.preBlock);
}

- (void)nextAction {
    BLOCK_EXEC(self.nextBlock);
}

- (void)resetPreNext {
    self.preButton.hidden = NO;
    self.nextButton.hidden = NO;
}

- (void)reachFirst {
    self.preButton.hidden = YES;
}

- (void)reachLast {
    self.nextButton.hidden = YES;
}

- (void)setClassName:(NSString *)className {
    _className = className;
    self.classNameLabel.text = className;
}

@end
