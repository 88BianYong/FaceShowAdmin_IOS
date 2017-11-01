//
//  SignInDetailHeaderView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInDetailHeaderView.h"

@interface SignInDetailHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *rateLabel;
@end

@implementation SignInDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"蓝色背景"]];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(20);
    }];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.titleLabel.mas_right);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(5);
    }];
    UIButton *qrButton = [[UIButton alloc]init];
    qrButton.backgroundColor = [UIColor redColor];
    [qrButton addTarget:self action:@selector(qrBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:qrButton];
    [qrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-60);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.12];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"539dd3"];
    [bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(1, 13));
    }];
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.font = [UIFont systemFontOfSize:14];
    self.countLabel.textColor = [UIColor colorWithHexString:@"99d5fe"];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(line.mas_left);
    }];
    self.rateLabel = [self.countLabel clone];
    [bottomView addSubview:self.rateLabel];
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(line.mas_right);
    }];
}

- (void)qrBtnAction {
    BLOCK_EXEC(self.qrBlock);
}

- (void)setData:(SignInListRequestItem_signIns *)data {
    _data = data;
    self.titleLabel.text = data.title;
    NSArray *startArr = [data.startTime componentsSeparatedByString:@" "];
    NSString *startDate = startArr.firstObject;
    startDate = [startDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *startTime = startArr.lastObject;
    startTime = [startTime substringToIndex:5];
    NSArray *endArr = [data.endTime componentsSeparatedByString:@" "];
    NSString *endDate = endArr.firstObject;
    endDate = [endDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTime = endArr.lastObject;
    endTime = [endTime substringToIndex:5];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ - %@",startDate,startTime,endTime];
    
    NSString *count = [NSString stringWithFormat:@"%@/%@",data.signInUserNum,data.totalUserNum];
    NSString *complete = [NSString stringWithFormat:@"签到人数：%@",count];
    NSRange range = [complete rangeOfString:count];
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:complete];
    [attrStr addAttributes:dic range:range];
    self.countLabel.attributedText = attrStr;
    
    NSString *percent = [NSString stringWithFormat:@"%.0f%@",data.percent.floatValue*100,@"%"];
    NSString *rate = [NSString stringWithFormat:@"签到率：%@",percent];
    range = [rate rangeOfString:percent];
    attrStr = [[NSMutableAttributedString alloc]initWithString:rate];
    [attrStr addAttributes:dic range:range];
    self.rateLabel.attributedText = attrStr;
}

@end
