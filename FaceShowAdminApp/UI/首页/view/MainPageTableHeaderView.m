//
//  MainPageTableHeaderView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MainPageTableHeaderView.h"
@interface MainPageNmuberView:UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@end
@implementation MainPageNmuberView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.size.mas_offset(CGSizeMake(13.0f, 13.0f));
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.nameLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(6.0f);
            make.centerY.equalTo(self.imageView.mas_centerY);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(12.0f);
        }];
        self.numberLabel = [[UILabel alloc] init];
        self.numberLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.numberLabel.font = [UIFont fontWithName:YXFontMetro_Light size:37.0f];
        [self addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(8.0f);
            make.centerX.equalTo(self.nameLabel.mas_centerX);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_offset(35.0f);
        }];
    }
    return self;
}

@end

@interface MainPageTableHeaderView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) MainPageNmuberView *courseView;
@property (nonatomic, strong) MainPageNmuberView *taskView;
@property (nonatomic, strong) UIView *lineView;

@end
@implementation MainPageTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    self.courseView = [[MainPageNmuberView alloc] init];
    self.courseView.imageView.image = [UIImage imageNamed:@"课程数量标签"];
    self.courseView.nameLabel.text = @"课程数量";
    self.courseView.numberLabel.text = self.clazsStatistic.courseNum;
    [self.containerView addSubview:self.courseView];
    
    self.taskView = [[MainPageNmuberView alloc] init];
    self.taskView.imageView.image = [UIImage imageNamed:@"任务数量标签"];
    self.taskView.nameLabel.text = @"任务数量";
    self.taskView.numberLabel.text = self.clazsStatistic.taskNum;
    [self.containerView addSubview:self.taskView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"dce0e3"];
    [self.containerView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(5.0f);
        make.bottom.equalTo(self.mas_bottom);
    }];

    [self.courseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX).multipliedBy(1.0f/2.0f).offset(-9.0f);
        make.centerY.equalTo(self.containerView.mas_centerY);
    }];
    
    [self.taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX).multipliedBy(3.0f/2.0f).offset(-9.0f);
        make.centerY.equalTo(self.containerView.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.containerView);
        make.size.mas_offset(CGSizeMake(1.0f, 30.0f));        
    }];
}
#pragma mark - set
- (void)setClazsStatistic:(ClazsGetClazsRequestItem_Data_ClazsStatisticView *)clazsStatistic {
    _clazsStatistic = clazsStatistic;
    self.courseView.numberLabel.text = _clazsStatistic.courseNum?:@"0";
    self.taskView.numberLabel.text = _clazsStatistic.taskNum?:@"0";
}
@end
