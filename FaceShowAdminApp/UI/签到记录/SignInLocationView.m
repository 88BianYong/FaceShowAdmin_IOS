//
//  SignInLocationView.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/5/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignInLocationView.h"

@interface SignInLocationView()
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *plcaeholderLabel;
@property (nonatomic, strong) UILabel *contentLabel;
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
    
    self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.iconButton setImage:[UIImage imageNamed:@"位置"] forState:UIControlStateNormal];
    [self addSubview:self.iconButton];
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconButton.mas_right).mas_offset(4);
        make.centerY.mas_equalTo(0);
    }];
    UILabel *plcaeholderLabel = [self.titleLabel clone];
    self.plcaeholderLabel = plcaeholderLabel;
    [self.titleLabel addSubview:plcaeholderLabel];
    [plcaeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIImageView *enterImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"进入页面按钮正常态"] highlightedImage:[UIImage imageNamed:@"进入页面按钮点击态"]];
    [self addSubview:enterImageView];
    [enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UIButton *b = [[UIButton alloc]init];
    [b addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:b];
    [b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    WEAK_SELF
    [RACObserve(b, highlighted) subscribeNext:^(id x) {
        STRONG_SELF
        enterImageView.highlighted = [x boolValue];
    }];
}

- (void)btnAction {
    BLOCK_EXEC(self.selectionBlock);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.plcaeholderLabel.hidden = YES;
    self.titleLabel.text = title;
}

- (void)setPlaceholderStr:(NSString *)placeholderStr {
    _placeholderStr = placeholderStr;
    self.plcaeholderLabel.text = placeholderStr;
}
@end

