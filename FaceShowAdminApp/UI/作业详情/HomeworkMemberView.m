//
//  HomeworkMemberView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HomeworkMemberView.h"

@interface HomeworkMemberView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation HomeworkMemberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.imageView = [[UIImageView alloc]init];
    self.imageView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = 11;
    self.imageView.clipsToBounds = YES;
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).mas_offset(10);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.imageView.mas_centerY);
    }];
    
    // mock mock
//    [self.imageView setBackgroundColor:[UIColor redColor]];
//    self.nameLabel.text = @"横扫一";
}

- (void)setHeadUrl:(NSString *)headUrl {
    _headUrl = headUrl;
    WEAK_SELF
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"聊聊默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        STRONG_SELF
        self.imageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
    }];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

@end
