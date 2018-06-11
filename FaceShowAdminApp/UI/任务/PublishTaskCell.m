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
        self.backgroundColor = [UIColor redColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.iconImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@""];
    self.nameLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:self.nameLabel];
    
}
- (void)setupLayout {
    
    
    
}
- (void)reloadTask:(NSString *)name defaultImage:(NSString *)icon highlightImage:(NSString *)image {
    //self.iconImageView
}
@end
