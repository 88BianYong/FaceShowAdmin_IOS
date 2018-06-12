//
//  TrainingProfileHeaderView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TrainingProfileHeaderView.h"
#import "ProvinceStatisticView.h"
#import "PercentStatisticView.h"

@interface TrainingProfileHeaderView ()
@property (nonatomic, strong) ProvinceStatisticView *provinceStatisticView;
@property (nonatomic, strong) PercentStatisticView *percentStatisticView;
@end

@implementation TrainingProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.provinceStatisticView = [[ProvinceStatisticView alloc]init];
    [self addSubview:self.provinceStatisticView];
    [self.provinceStatisticView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(235);
    }];
    self.percentStatisticView = [[PercentStatisticView alloc]init];
    [self addSubview:self.percentStatisticView];
    [self.percentStatisticView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.provinceStatisticView.mas_bottom).mas_offset(5);
    }];
}

@end
