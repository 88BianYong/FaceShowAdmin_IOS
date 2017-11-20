//
//  NoticeListCell.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeListCell.h"
@interface NoticeListCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UIView *lineView;

@end
@implementation NoticeListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.contentView addSubview:self.titleLabel];
    
    self.readLabel = [[UILabel alloc] init];
    self.readLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
    self.readLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    self.readLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.readLabel];

    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.timeLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.font = [UIFont systemFontOfSize:13.0];
    self.contentLabel.numberOfLines = 2;
    [self.contentView addSubview:self.contentLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(17.0f);
        make.right.mas_equalTo(-100);
    }];
    
    [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
//        make.left.greaterThanOrEqualTo(self.titleLabel.mas_right).offset(10.0f);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9.0f);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(12.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(1.0f);
    }];
}
- (void)reloadCell:(NoticeListRequestItem_Data_NoticeInfos_Elements *)element withStudentNum:(NSString *)number {
    self.titleLabel.text = element.title;
    self.timeLabel.text = [[element.createTime omitSecondOfFullDateString] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSMutableParagraphStyle *cStyle = [[NSMutableParagraphStyle alloc] init];
    cStyle.lineHeightMultiple = 1.2f;
    cStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    self.contentLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:element.content?:@"" attributes:@{NSParagraphStyleAttributeName:cStyle}];
    
    NSString *readString = [NSString stringWithFormat:@"已阅读: %@/%@",element.noticeReadUserNum?:@"0",number];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:readString];
    [attString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],
                               NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]} range:NSMakeRange(0, 3)];
    self.readLabel.attributedText = attString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
