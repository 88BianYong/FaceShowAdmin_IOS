//
//  EditQuestionTableHeaderView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "EditQuestionTableHeaderView.h"
#import "EditQuestionTypeView.h"
@interface EditQuestionTableHeaderView ()
@property (nonatomic, strong) EditQuestionTypeView *firstView;
@property (nonatomic, strong) UIView *oneLineView;
@property (nonatomic, strong) EditQuestionTypeView *secondView;
@property (nonatomic, strong) UIView *twoLineView;
@property (nonatomic, strong) EditQuestionTypeView *thirdView;
@property (nonatomic, strong) UIView *bottomView;
@end
@implementation EditQuestionTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setTag:(NSInteger)tag {
    [super setTag:tag];
    if (tag == 1) {
        self.firstView.selected = YES;
    }else if (tag == 2){
        self.secondView.selected = YES;
    }else {
        self.thirdView.selected = YES;
    }
}
#pragma mark - setupUI
- (void)setupUI {
    self.firstView = [[EditQuestionTypeView alloc] init];
    WEAK_SELF
    [[self.firstView.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.firstView.selected = YES;
        self.secondView.selected = NO;
        self.thirdView.selected = NO;
        BLOCK_EXEC(self.questionTypeBlock,@"1");
    }];
    self.firstView.selected = YES;
    self.firstView.titleString = @"单选";
    [self addSubview:self.firstView];
    self.secondView = [[EditQuestionTypeView alloc] init];
    [[self.secondView.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.firstView.selected = NO;
        self.secondView.selected = YES;
        self.thirdView.selected = NO;
        BLOCK_EXEC(self.questionTypeBlock,@"2");
    }];
    self.secondView.titleString = @"多选";
    [self addSubview:self.secondView];
    self.thirdView = [[EditQuestionTypeView alloc] init];
    [[self.thirdView.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.firstView.selected = NO;
        self.secondView.selected = NO;
        self.thirdView.selected = YES;
        BLOCK_EXEC(self.questionTypeBlock,@"3");
    }];
    self.thirdView.titleString = @"主观题";
    [self addSubview:self.thirdView];
    
    self.oneLineView = [[UIView alloc] init];
    self.oneLineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:self.oneLineView];
    
    self.twoLineView = [[UIView alloc] init];
    self.twoLineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:self.twoLineView];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:self.bottomView];
}
- (void)setupLayout {
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(45.0f);
        make.top.equalTo(self.mas_top).offset(5.0f);
    }];
    [self.oneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f).priorityHigh();
        make.right.equalTo(self.mas_right).priorityHigh();
        make.top.equalTo(self.firstView.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(45.0f);
        make.top.equalTo(self.oneLineView.mas_bottom);
    }];
    [self.twoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f).priorityHigh();
        make.right.equalTo(self.mas_right).priorityHigh();
        make.top.equalTo(self.secondView.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(45.0f);
        make.top.equalTo(self.twoLineView.mas_bottom);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_offset(5.0f);
    }];
}
- (void)reloadSelected {
    self.firstView.selected = YES;
    self.secondView.selected = NO;
    self.thirdView.selected = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
