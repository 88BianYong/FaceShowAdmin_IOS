//
//  QuestionTemplatesCell.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "QuestionTemplatesCell.h"
@interface QuestionTemplatesCell ()
@property (nonatomic, strong) UIView *typeView;
@property (nonatomic, strong) UILabel *contentLabel;
@end
@implementation QuestionTemplatesCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutIfNeeded];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.typeView = [[UIView alloc] init];
    self.typeView.layer.borderColor = [UIColor colorWithHexString:@"d5d8db"].CGColor;
    self.typeView.layer.borderWidth = 1.0f;
    [self.contentView addSubview:self.typeView];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:15.0f];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
}
- (void)setupLayout {
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.size.mas_offset(CGSizeMake(15.0f, 15.0f));
        make.top.equalTo(self.contentView.mas_top).offset(1.0f);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeView.mas_right).offset(5.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20.0f);
    }];
}
- (void)reloadTemplate:(NSString *)title withType:(NSInteger)type {
    self.contentLabel.text = title;
    if (type == 2) {
        self.typeView.layer.cornerRadius = 3.0f;
    }else {
        self.typeView.layer.cornerRadius = 7.5f;
    }
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
