//
//  ScoreAverageView.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/21.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScoreAverageView.h"

@interface ScoreAverageView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@end

@implementation ScoreAverageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.titleLabel.text = @"班级平均分";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.centerX.mas_equalTo(0);
    }];
    
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:45];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"1da1f2"];
    [self addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
        make.centerX.mas_equalTo(0);
    }];
}

- (void)setAverageValue:(NSString *)averageValue {
    _averageValue = averageValue;
    self.scoreLabel.text = averageValue;
}
@end
