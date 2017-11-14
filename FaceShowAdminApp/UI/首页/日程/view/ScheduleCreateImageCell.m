//
//  ScheduleImageCell.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScheduleCreateImageCell.h"

@implementation ScheduleCreateImageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
        self.isContainImage = NO;
    }
    return self;
}
- (void)setIsContainImage:(BOOL)isContainImage {
    _isContainImage = isContainImage;
    self.chooseButton.hidden = _isContainImage;
    self.photoImageView.hidden = !_isContainImage;
    self.deleteButton.hidden = !_isContainImage;
    [self.photoImageView removeSubviews];
}
#pragma mark - setupUI
- (void)setupUI {
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseButton setImage:[UIImage imageNamed:@"添加图片按钮框正常态"] forState:UIControlStateNormal];
    [self.chooseButton setImage:[UIImage imageNamed:@"添加图片按钮框点击态"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.chooseButton];
    
    self.photoImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.photoImageView];
    
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[UIImage imageNamed:@"小图片删除按钮正常态"] forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"小图片删除按钮点击态"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.deleteButton];
}
- (void)setupLayout {
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(90.0f, 90.0f));
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
    }];
    
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.width.equalTo(self.photoImageView.mas_height);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.top.equalTo(self.contentView.mas_top).offset(10.0f);
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
