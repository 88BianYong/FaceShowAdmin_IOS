//
//  ClassDetailStatisticItemView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassDetailStatisticItemView.h"

@interface ClassDetailStatisticItemView()
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation ClassDetailStatisticItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.font = [UIFont boldSystemFontOfSize:22];
    self.numberLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    self.nameLabel = [self.numberLabel clone];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"c2c7ce"];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numberLabel.mas_bottom).mas_offset(8);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

- (void)setNumber:(NSString *)number {
    _number = number;
    self.numberLabel.text = number;
}

@end
