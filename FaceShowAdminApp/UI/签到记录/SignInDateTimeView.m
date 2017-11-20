//
//  SignInDateTimeView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInDateTimeView.h"

@interface SignInDateTimeView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation SignInDateTimeView

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
    UIImageView *enterImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"进入页面按钮正常态"] highlightedImage:[UIImage imageNamed:@"进入页面按钮点击态"]];
    [self addSubview:enterImageView];
    [enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(enterImageView.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(0);
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
    self.titleLabel.text = title;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
}

@end
