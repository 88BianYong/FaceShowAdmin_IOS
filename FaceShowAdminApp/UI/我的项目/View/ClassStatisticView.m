//
//  ClassStatisticView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassStatisticView.h"
#import "PercentStatisticItemView.h"

@interface ClassStatisticView()
@property (nonatomic, strong) PercentStatisticItemView *completeView;
@property (nonatomic, strong) PercentStatisticItemView *signinView;
@property (nonatomic, strong) PercentStatisticItemView *useView;
@end

@implementation ClassStatisticView

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
    self.completeView = [[PercentStatisticItemView alloc]init];
    self.completeView.name = @"任务完成率";
    [self addSubview:self.completeView];
    [self.completeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(1.0/3.0);
    }];
    self.signinView = [[PercentStatisticItemView alloc]init];
    self.signinView.name = @"学员平均积分";
    [self addSubview:self.signinView];
    [self.signinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    self.useView = [[PercentStatisticItemView alloc]init];
    self.useView.name = @"学员签到率";
    [self addSubview:self.useView];
    [self.useView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(5.0/3.0);
    }];
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 34));
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(2.0/3.0);
    }];
    UIView *line2 = [line1 clone];
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 34));
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(4.0/3.0);
    }];
}

- (void)setData:(GetCountClazsRequestItem_data *)data {
    self.completeView.percent = [NSString stringWithFormat:@"%.0f%@",[data.taskFinishedRate floatValue]* 100,@"%"];
    self.signinView.percent = data.studentAvgScore;
    self.useView.percent = [NSString stringWithFormat:@"%.0f%@",[data.studentReportRate floatValue]* 100,@"%"];;
}

@end
