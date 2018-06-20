//
//  EditQuestionTypeView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "EditQuestionTypeView.h"
@interface EditQuestionTypeView ()
@property (nonatomic, strong) UIView *typeView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation EditQuestionTypeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - set
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (_selected) {
        self.typeView.layer.borderColor = [UIColor colorWithHexString:@"0068bd"].CGColor;
        self.typeView.layer.borderWidth = 6.0f;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
    }else {
        self.typeView.layer.borderColor = [UIColor colorWithHexString:@"d5d8db"].CGColor;
        self.typeView.layer.borderWidth = 2.0f;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        
    }
}
- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = _titleString;
}
#pragma mark - setupUI
- (void)setupUI {
    self.typeView = [[UIView alloc] init];
    self.typeView.layer.cornerRadius = 11.0f;
    [self addSubview:self.typeView];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:self.titleLabel];
    self.selected = NO;
    self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.clickButton];

}
- (void)setupLayout {
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(22.0f, 22.0f));
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15.0f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeView.mas_right).offset(20.0f);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
