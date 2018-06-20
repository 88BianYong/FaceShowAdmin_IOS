//
//  EditQuestionFooterView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "EditQuestionFooterView.h"
@interface EditQuestionFooterView ()
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation EditQuestionFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.statusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"添加选项"]];
    [self.contentView addSubview:self.statusImageView];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.titleLabel.text = @"添加选项";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    WEAK_SELF
    [[self.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.addQuestionBlock);
    }];
    [self.contentView addSubview:self.clickButton];
}
- (void)setupLayout {
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.size.mas_offset(CGSizeMake(21.0f, 21.0f));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusImageView.mas_right).offset(15.0);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
}
@end
