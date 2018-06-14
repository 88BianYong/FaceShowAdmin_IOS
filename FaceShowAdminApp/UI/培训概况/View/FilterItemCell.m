//
//  FilterItemCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "FilterItemCell.h"

@interface FilterItemCell ()
@property (nonatomic, strong) UIButton *itemButton;
@end

@implementation FilterItemCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.itemButton = [[UIButton alloc]init];
    UIImage *normalImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"ebeff2"]];
    UIImage *selectedImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"0068bd"]];
    [self.itemButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.itemButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self.itemButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [self.itemButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    self.itemButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.itemButton.layer.cornerRadius = 5;
    self.itemButton.clipsToBounds = YES;
    [self.itemButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.itemButton];
    [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)btnAction:(UIButton *)button {
    BLOCK_EXEC(self.clickBlock,self);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.itemButton setTitle:title forState:UIControlStateNormal];
}

- (void)setIsCurrent:(BOOL)isCurrent {
    _isCurrent = isCurrent;
    self.itemButton.selected = isCurrent;
}
@end
