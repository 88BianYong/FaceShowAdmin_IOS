//
//  CourseCommentCell.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCommentCell.h"

@interface CourseCommentCell()
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UILabel *favorLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation CourseCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *bottomLine = [[UIView alloc]init];
    self.bottomLine = bottomLine;
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"d7dde0"];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.headImageView = [[UIImageView alloc]init];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.cornerRadius = 5;
    self.headImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.headImageView.mas_top).mas_offset(5);
    }];
    self.commentLabel = [[UILabel alloc]init];
    self.commentLabel.font = [UIFont systemFontOfSize:14];
    self.commentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.commentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(8);
    }];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commentLabel.mas_left);
        make.top.mas_equalTo(self.commentLabel.mas_bottom).mas_offset(20);
        make.bottom.mas_equalTo(-30);
    }];
    
    self.menuButton = [[UIButton alloc]init];
    [self.menuButton setBackgroundImage:[UIImage imageNamed:@"赞评论展开按钮张常态"] forState:UIControlStateNormal];
    [self.menuButton setBackgroundImage:[UIImage imageNamed:@"赞评论展开按钮-点击态"] forState:UIControlStateHighlighted];
    [self.menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.menuButton];
    [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.favorLabel = [[UILabel alloc]init];
    self.favorLabel.font = [UIFont systemFontOfSize:13];
    self.favorLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.favorLabel];
    [self.favorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.menuButton.mas_left).mas_offset(-3);
        make.centerY.mas_equalTo(self.menuButton.mas_centerY);
    }];
}

- (void)menuAction:(UIButton *)sender {
    BLOCK_EXEC(self.menuBlock,sender);
}

- (void)setBottomLineHidden:(BOOL)bottomLineHidden {
    _bottomLineHidden = bottomLineHidden;
    self.bottomLine.hidden = bottomLineHidden;
}

- (void)setItem:(GetCourseCommentRequestItem_element *)item {
    _item = item;
    WEAK_SELF
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:[UIImage imageNamed:@"班级圈小默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        STRONG_SELF
        self.headImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
    }];
    self.nameLabel.text = item.userName;
    NSString *comment = item.content;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:comment attributes:dic];
    self.commentLabel.attributedText = attributeStr;
    self.favorLabel.text = [NSString stringWithFormat:@"%@个赞",item.likeNum];
    self.timeLabel.text = [self dateStringFromOriString:item.createTime];
}

- (NSString *)dateStringFromOriString:(NSString *)oriStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:oriStr];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:self.currentTime.doubleValue/1000];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:date];
    if (interval >= 24*60*60) {
        NSString *displayStr = [oriStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        displayStr = [displayStr substringToIndex:displayStr.length-3];
        return displayStr;
    }else if (interval < 60) {
        return @"刚刚";
    }else if (interval < 60*60) {
        NSInteger min = interval/60;
        return [NSString stringWithFormat:@"%@分钟前",@(min)];
    }else {
        NSInteger hour = interval/60/60;
        return [NSString stringWithFormat:@"%@小时前",@(hour)];
    }
}


@end
