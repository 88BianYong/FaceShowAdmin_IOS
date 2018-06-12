//
//  NameNumberView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NameNumberView.h"

@interface NameNumberView()
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation NameNumberView

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
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    self.nameLabel = [self.numberLabel clone];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
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
