//
//  FilterHeaderView.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FilterHeaderView.h"

@interface FilterHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation FilterHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

@end
