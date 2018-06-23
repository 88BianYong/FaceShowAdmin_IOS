//
//  CreateEvaluateCell.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateEvaluateCell.h"
@interface CreateEvaluateCell ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIButton *previewButton;
@end
@implementation CreateEvaluateCell
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
- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    if (_enabled) {
        self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.nameLabel.highlightedTextColor = [UIColor colorWithHexString:@"0068bd"];
        self.selectedImageView.highlightedImage = [UIImage imageNamed:@"选择按钮"];

    }else {
        self.nameLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.nameLabel.highlightedTextColor = [UIColor colorWithHexString:@"999999"];
        self.selectedImageView.highlightedImage = nil;
    }
    self.userInteractionEnabled =_enabled;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
}
#pragma mark - setupUI
- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.selectedBackgroundView = selectedBgView;
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.nameLabel.highlightedTextColor = [UIColor colorWithHexString:@"0068bd"];
    [self.contentView addSubview:self.nameLabel];
    
    self.selectedImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.selectedImageView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.lineView];
    
    self.previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    WEAK_SELF
    [[self.previewButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.previewTemplateBlock);
    }];
    [self.contentView addSubview:self.previewButton];
}
- (void)setupLayout {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_offset(1.0f);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.lessThanOrEqualTo(self.selectedImageView.mas_left).offset(-15.0f);
    }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-9.0f);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
    }];
    
    [self.previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.nameLabel.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}
@end
