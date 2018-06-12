//
//  SubordinateCourseCell.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SubordinateCourseCell.h"
@interface SubordinateCourseCell()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *selectedImageView;
@end
@implementation SubordinateCourseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.nameLabel.text = _titleString;
}
#pragma mark - setupUI
- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.lineView = [[UIView alloc] init];
    [self.contentView addSubview:self.lineView];
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:12.0f];
    self.nameLabel.textColor = [UIColor colorWithHexString:@""];
    [self.contentView addSubview:self.nameLabel];
    
    self.selectedImageView = [[UIImageView alloc] init];
    self.selectedImageView.highlightedImage = [UIImage imageNamed:@"选择图标"];
    [self.contentView addSubview:self.selectedImageView];
 }
- (void)setupLayout {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_offset(1.0f);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.selectedImageView.mas_left).offset(-15.0f);
    }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.size.mas_offset(CGSizeMake(25.0f, 25.0f));
    }];
    
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
