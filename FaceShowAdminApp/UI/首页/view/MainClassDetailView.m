//
//  MainClassDetailView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MainClassDetailView.h"
@interface MainClassDetailView ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *scroolView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *studentLabel;
@property (nonatomic, strong) UILabel *teacherLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation MainClassDetailView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma makr - set
- (void)setItemData:(ClazsGetClazsRequestItem_Data *)itemData {
    _itemData = itemData;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_itemData.clazsInfo.clazsName?:@""];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _itemData.clazsInfo.clazsName.length)];
    self.titleLabel.attributedText = attributedString;
    NSArray *startArr = [_itemData.clazsInfo.startTime componentsSeparatedByString:@" "];
    NSString *startDate = startArr.firstObject;
    startDate = [startDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSArray *endArr = [_itemData.clazsInfo.endTime componentsSeparatedByString:@" "];
    NSString *endDate = endArr.firstObject;
    endDate = [endDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",startDate,endDate];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:_itemData.clazsInfo.desc?:@""];
    [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _itemData.clazsInfo.desc.length)];
    self.contentLabel.attributedText = att;
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    
    self.studentLabel.text = [NSString stringWithFormat:@"班级学员: %@人",_itemData.clazsStatisticView.studensNum?:@""];
    self.teacherLabel.text = [NSString stringWithFormat:@"班主任: %@人",_itemData.clazsStatisticView.masterNum?:@""];
    
    NSInteger height = ceilf([self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.bounds.size.width, MAXFLOAT)].height);
    self.scroolView.contentSize = CGSizeMake(SCREEN_WIDTH- 10.0f, height + 120.0f);
}
#pragma mark - setupUI
- (void)setupUI {
    self.scroolView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scroolView.showsHorizontalScrollIndicator = NO;
    self.scroolView.showsVerticalScrollIndicator = NO;
    self.scroolView.directionalLockEnabled = YES;
    self.scroolView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.scroolView.delaysContentTouches = NO;
    self.scroolView.contentSize = CGSizeMake(SCREEN_WIDTH - 10.0f, 400.0f);
    [self addSubview:self.scroolView];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.scroolView addSubview:self.containerView];
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.containerView addSubview:self.topView];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"详情页背景图"]];
    [self.containerView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.timeLabel];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.textColor = [UIColor colorWithHexString:@"3333333"];
    self.descLabel.font = [UIFont systemFontOfSize:13.0f];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel.text = @"- 班级描述 -";
    [self.containerView addSubview:self.descLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.containerView addSubview:self.contentLabel];
    
    self.studentLabel = [[UILabel alloc] init];
    self.studentLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.studentLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.studentLabel.textAlignment = NSTextAlignmentRight;
    [self.containerView addSubview:self.studentLabel];

    self.teacherLabel = [[UILabel alloc] init];
    self.teacherLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.teacherLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [self.containerView addSubview:self.teacherLabel];

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"939699"];
    [self.containerView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.scroolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scroolView.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top);
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.height.mas_offset(5.0f);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.width.equalTo(self.imageView.mas_height).multipliedBy(750.0f/240.f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(25.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-25.0f);
        make.top.equalTo(self.imageView.mas_top).offset(25.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15.0f);
    }];
    
    [self.studentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lineView.mas_left).offset(-15.0f);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(18.0f);
    }];
    [self.teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(15.0f);
        make.centerY.equalTo(self.studentLabel.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(1.0f, 13.0f));
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.centerY.equalTo(self.teacherLabel.mas_centerY);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.studentLabel.mas_bottom).offset(18.0f);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f);
        make.top.equalTo(self.descLabel.mas_bottom).offset(12.0f);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
}
@end
