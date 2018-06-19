//
//  TaskChooseContentView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "TaskChooseContentView.h"
@interface TaskChooseContentView ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UIButton *clickButton;
@end
@implementation TaskChooseContentView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.chooseType = SubordinateCourse_Class;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setChooseContentString:(NSString *)chooseContentString {
    _chooseContentString = chooseContentString;
    self.contentLabel.text = _chooseContentString;
}
#pragma mark - setupUI
- (void)setupUI {
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
    self.nameLabel.text = @"所属课程";
    [self addSubview:self.nameLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.contentLabel];
    
    self.nextImageView = [[UIImageView alloc] init];
    self.nextImageView.image = [UIImage imageNamed:@"进入页面按钮正常态"];
    [self addSubview:self.nextImageView];
    
    self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.clickButton];
    WEAK_SELF
    [[self.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.nextImageView.image = [UIImage imageNamed:@"进入页面按钮正常态"];
        BLOCK_EXEC(self.pushSubordinateCourseBlock);
    }];
    [[self.clickButton rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        STRONG_SELF
        self.nextImageView.image = [UIImage imageNamed:@"进入页面按钮点击态"];
    }];
    [[self.clickButton rac_signalForControlEvents:UIControlEventTouchDragOutside] subscribeNext:^(id x) {
        STRONG_SELF
        self.nextImageView.image = [UIImage imageNamed:@"进入页面按钮正常态"];
    }];
}
- (void)setupLayout {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_offset(100.0f);
    }];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_offset(CGSizeMake(30.0f, 30.0f));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextImageView.mas_left).offset(-5.0f);
        make.left.equalTo(self.nameLabel.mas_right).offset(10.0f);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
@end
