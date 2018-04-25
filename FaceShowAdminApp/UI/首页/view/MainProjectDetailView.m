//
//  MainProjectDetailView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MainProjectDetailView.h"
@interface MainProjectDetailView ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *scroolView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end
@implementation MainProjectDetailView
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
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_itemData.projectInfo.projectName?:@""];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _itemData.projectInfo.projectName.length)];
    self.titleLabel.attributedText = attributedString;
    
    NSArray *startArr = [_itemData.projectInfo.startTime componentsSeparatedByString:@" "];
    NSString *startDate = startArr.firstObject;
    startDate = [startDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSArray *endArr = [_itemData.projectInfo.endTime componentsSeparatedByString:@" "];
    NSString *endDate = endArr.firstObject;
    endDate = [endDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",startDate,endDate];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:_itemData.projectInfo.desc?:@""];
    [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _itemData.projectInfo.desc.length)];
    self.contentLabel.attributedText = att;
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    
     NSInteger height = ceilf([self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.bounds.size.width, MAXFLOAT)].height);
    self.scroolView.contentSize = CGSizeMake(SCREEN_WIDTH, height + 120.0f);
}
#pragma mark - setupUI
- (void)setupUI {
    self.scroolView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scroolView.showsHorizontalScrollIndicator = NO;
    self.scroolView.showsVerticalScrollIndicator = NO;
    self.scroolView.directionalLockEnabled = YES;
    self.scroolView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.scroolView.contentSize = CGSizeMake(SCREEN_WIDTH, 400.0f);
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
    self.titleLabel.numberOfLines = 0;
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
    self.descLabel.text = @"- 项目描述 -";
    [self.containerView addSubview:self.descLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.font = [UIFont systemFontOfSize:13.0f];
    self.contentLabel.numberOfLines = 0;
    [self.containerView addSubview:self.contentLabel];
    
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
        make.left.equalTo(self.containerView.mas_left).offset(20.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-25.0f);
        make.top.equalTo(self.imageView.mas_top).offset(25.0f);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12.0f);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(18.0f);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f);
        make.top.equalTo(self.descLabel.mas_bottom).offset(10.0f);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
}
@end
