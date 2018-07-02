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
@property (nonatomic, strong) ClassDetailStatisticItemView *teacherView;
@property (nonatomic, strong) ClassDetailStatisticItemView *studentView;
@property (nonatomic, strong) ClassDetailStatisticItemView *appUsedView;
@property (nonatomic, strong) ClassDetailStatisticItemView *courseView;
@property (nonatomic, strong) ClassDetailStatisticItemView *taskView;
@property (nonatomic, strong) ClassDetailStatisticItemView *signedView;
@property (nonatomic, strong) ClassDetailStatisticItemView *momentView;
@property (nonatomic, strong) ClassDetailStatisticItemView *resourceView;
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
    self.teacherView = [[ClassDetailStatisticItemView alloc]init];
    self.teacherView.name = @"班主任";
    [self addSubview:self.teacherView];
    [self.teacherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(1.0/3.0);
    }];
    self.studentView = [[ClassDetailStatisticItemView alloc]init];
    self.studentView.name = @"学员";
    [self addSubview:self.studentView];
    [self.studentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teacherView.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    self.appUsedView = [[ClassDetailStatisticItemView alloc]init];
    self.appUsedView.name = @"APP使用";
    [self addSubview:self.appUsedView];
    [self.appUsedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teacherView.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(5.0/3.0);
    }];
    self.courseView = [[ClassDetailStatisticItemView alloc]init];
    self.courseView.name = @"课程数量";
    [self addSubview:self.courseView];
    [self.courseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teacherView.mas_bottom).mas_offset(25);
        make.centerX.mas_equalTo(self.teacherView.mas_centerX);
    }];
    self.taskView = [[ClassDetailStatisticItemView alloc]init];
    self.taskView.name = @"任务总数";
    [self addSubview:self.taskView];
    [self.taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.courseView.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    self.signedView = [[ClassDetailStatisticItemView alloc]init];
    self.signedView.name = @"签到数量";
    [self addSubview:self.signedView];
    [self.signedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.courseView.mas_top);
        make.centerX.mas_equalTo(self.appUsedView.mas_centerX);
    }];
    self.momentView = [[ClassDetailStatisticItemView alloc]init];
    self.momentView.name = @"班级圈";
    [self addSubview:self.momentView];
    [self.momentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.courseView.mas_bottom).mas_offset(25);
        make.centerX.mas_equalTo(self.courseView.mas_centerX);
        make.bottom.mas_equalTo(-22);
    }];
    self.resourceView = [[ClassDetailStatisticItemView alloc]init];
    self.resourceView.name = @"资源数量";
    [self addSubview:self.resourceView];
    [self.resourceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.momentView.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    self.commentView = [[ClassDetailStatisticItemView alloc]init];
    self.commentView.name = @"项目满意度";
    [self addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.momentView.mas_top);
        make.centerX.mas_equalTo(self.signedView.mas_centerX);
    }];
}

- (void)setData:(GetCountClazsRequestItem_data *)data {
    self.teacherView.number = data.masterNum;
    self.studentView.number = data.studentNum;
    self.appUsedView.number = [NSString stringWithFormat:@"%@/%@",data.appUsedNum,data.studentNum];
    self.courseView.number = data.courseNum;
    self.taskView.number = data.taskNum;
    self.signedView.number = data.signedNum;
    self.momentView.number = data.momentNum;
    self.resourceView.number = data.resourceNum;
    self.commentView.number = [NSString stringWithFormat:@"%.0f%@",[data.projectSatisfiedPercent floatValue] * 100,@"%"];
}

@end
