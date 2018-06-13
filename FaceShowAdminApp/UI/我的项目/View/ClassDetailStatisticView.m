//
//  ClassDetailStatisticView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ClassDetailStatisticView.h"
#import "ClassDetailStatisticItemView.h"

@interface ClassDetailStatisticView ()
@property (nonatomic, strong) ClassDetailStatisticItemView *courseView;
@property (nonatomic, strong) ClassDetailStatisticItemView *homeworkView;
@property (nonatomic, strong) ClassDetailStatisticItemView *signinView;
@property (nonatomic, strong) ClassDetailStatisticItemView *resourceView;
@property (nonatomic, strong) ClassDetailStatisticItemView *classMomentView;
@property (nonatomic, strong) ClassDetailStatisticItemView *taskView;
@property (nonatomic, strong) ClassDetailStatisticItemView *studentView;
@property (nonatomic, strong) ClassDetailStatisticItemView *teacherView;
@property (nonatomic, strong) ClassDetailStatisticItemView *commentView;
@end

@implementation ClassDetailStatisticView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.courseView = [[ClassDetailStatisticItemView alloc]init];
    self.courseView.name = @"课程数量";
    [self addSubview:self.courseView];
    [self.courseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(1.0/3.0);
    }];
    self.homeworkView = [[ClassDetailStatisticItemView alloc]init];
    self.homeworkView.name = @"作业数量";
    [self addSubview:self.homeworkView];
    [self.homeworkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.courseView.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    self.signinView = [[ClassDetailStatisticItemView alloc]init];
    self.signinView.name = @"签到数量";
    [self addSubview:self.signinView];
    [self.signinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.courseView.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(5.0/3.0);
    }];
    self.resourceView = [[ClassDetailStatisticItemView alloc]init];
    self.resourceView.name = @"资源数量";
    [self addSubview:self.resourceView];
    [self.resourceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.courseView.mas_bottom).mas_offset(25);
        make.centerX.mas_equalTo(self.courseView.mas_centerX);
    }];
    self.classMomentView = [[ClassDetailStatisticItemView alloc]init];
    self.classMomentView.name = @"班级圈";
    [self addSubview:self.classMomentView];
    [self.classMomentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resourceView.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    self.taskView = [[ClassDetailStatisticItemView alloc]init];
    self.taskView.name = @"任务总数";
    [self addSubview:self.taskView];
    [self.taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resourceView.mas_top);
        make.centerX.mas_equalTo(self.signinView.mas_centerX);
    }];
    self.studentView = [[ClassDetailStatisticItemView alloc]init];
    self.studentView.name = @"学员";
    [self addSubview:self.studentView];
    [self.studentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resourceView.mas_bottom).mas_offset(25);
        make.centerX.mas_equalTo(self.resourceView.mas_centerX);
        make.bottom.mas_equalTo(-22);
    }];
    self.teacherView = [[ClassDetailStatisticItemView alloc]init];
    self.teacherView.name = @"班主任";
    [self addSubview:self.teacherView];
    [self.teacherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.studentView.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    self.commentView = [[ClassDetailStatisticItemView alloc]init];
    self.commentView.name = @"项目评价";
    [self addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.studentView.mas_top);
        make.centerX.mas_equalTo(self.taskView.mas_centerX);
    }];
    
    // mock mock
    self.courseView.number = @"30";
    self.homeworkView.number = @"4";
    self.signinView.number = @"22";
    self.resourceView.number = @"77";
    self.taskView.number = @"6";
    self.classMomentView.number = @"8";
    self.studentView.number = @"123";
    self.teacherView.number = @"5";
    self.commentView.number = @"99";
}

@end
