//
//  PublishTaskCell.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PublishTaskCell.h"
@interface PublishTaskCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@end
@implementation PublishTaskCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.nameLabel];
    
}
- (void)setupLayout {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(45.0f, 45.0f));
        make.top.equalTo(self.contentView.mas_top);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(8.0f);
    }]; 
}
- (void)reloadTask:(NSString *)name defaultImage:(NSString *)icon highlightImage:(NSString *)image {
    self.iconImageView.image = [UIImage imageNamed:icon];
    self.nameLabel.text = name;
}
@end
