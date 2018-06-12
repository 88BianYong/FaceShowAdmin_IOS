//
//  PercentStatisticItemView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PercentStatisticItemView.h"

@interface PercentStatisticItemView()
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation PercentStatisticItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.percentLabel = [[UILabel alloc]init];
    self.percentLabel.font = [UIFont boldSystemFontOfSize:22];
    self.percentLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.percentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.percentLabel];
    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"c2c7ce"];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.percentLabel.mas_bottom).mas_offset(8);
        make.bottom.centerX.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
}

- (void)setPercent:(NSString *)percent {
    _percent = percent;
    self.percentLabel.text = percent;
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

- (void)setPercentColor:(UIColor *)percentColor {
    _percentColor = percentColor;
    self.percentLabel.textColor = percentColor;
}
@end
