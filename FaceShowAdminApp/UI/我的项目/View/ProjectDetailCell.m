//
//  ProjectDetailCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ProjectDetailCell.h"
#import "PercentStatisticItemView.h"

@interface ProjectDetailCell()
@property (nonatomic, strong) PercentStatisticItemView *statisticView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *classNumberLabel;
@property (nonatomic, strong) UILabel *studentNumberLabel;
@property (nonatomic, strong) UILabel *teacherNumberLabel;
@end

@implementation ProjectDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(106);
    }];
    self.statisticView = [[PercentStatisticItemView alloc]init];
    self.statisticView.name = @"任务完成率";
    [bgView addSubview:self.statisticView];
    [self.statisticView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-30);
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(16);
        make.right.mas_lessThanOrEqualTo(self.statisticView.mas_left).mas_offset(-30);
    }];
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [bgView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(11);
        make.right.mas_equalTo(self.titleLabel.mas_right);
    }];
    UILabel *classLabel = [self.dateLabel clone];
    classLabel.text = @"班级";
    [bgView addSubview:classLabel];
    [classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.dateLabel.mas_bottom).mas_offset(11);
    }];
    self.classNumberLabel = [[UILabel alloc]init];
    self.classNumberLabel.font = [UIFont systemFontOfSize:14];
    self.classNumberLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
    [bgView addSubview:self.classNumberLabel];
    [self.classNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(classLabel.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(classLabel.mas_centerY);
        make.width.mas_equalTo(38);
    }];
    UILabel *studentLabel = [classLabel clone];
    studentLabel.text = @"学员";
    [bgView addSubview:studentLabel];
    [studentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.classNumberLabel.mas_right);
        make.centerY.mas_equalTo(classLabel.mas_centerY);
    }];
    self.studentNumberLabel = [self.classNumberLabel clone];
    [bgView addSubview:self.studentNumberLabel];
    [self.studentNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(studentLabel.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(classLabel.mas_centerY);
        make.width.mas_equalTo(self.classNumberLabel.mas_width);
    }];
    UILabel *teacherLabel = [classLabel clone];
    teacherLabel.text = @"班主任";
    [bgView addSubview:teacherLabel];
    [teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.studentNumberLabel.mas_right);
        make.centerY.mas_equalTo(classLabel.mas_centerY);
    }];
    self.teacherNumberLabel = [self.classNumberLabel clone];
    [bgView addSubview:self.teacherNumberLabel];
    [self.teacherNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(teacherLabel.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(classLabel.mas_centerY);
        make.width.mas_equalTo(self.classNumberLabel.mas_width);
    }];
}

- (void)setData:(GetMyProjectsRequestItem_project *)data {
    _data = data;
    self.titleLabel.text = data.projectName;
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@",[data.startTime omitSecondOfFullDateString],[data.endTime omitSecondOfFullDateString]];
    self.classNumberLabel.text = data.clazsNum;
    self.studentNumberLabel.text = data.studentNum;
    self.teacherNumberLabel.text = data.masterNum;
    self.statisticView.percent = [NSString stringWithFormat:@"%.0f%@",data.taskFinishedRate.floatValue,@"%"];
}

- (void)setType:(ProjectGroupType)type {
    if (type == ProjectGroup_InProgress) {
        self.statisticView.percentColor = [UIColor colorWithHexString:@"e5581a"];
    }else if (type == ProjectGroup_Complete) {
        self.statisticView.percentColor = [UIColor colorWithHexString:@"c2c7ce"];
    }else if (type == ProjectGroup_NotStarted) {
        self.statisticView.percent = @"-";
        self.statisticView.percentColor = [UIColor colorWithHexString:@"e5581a"];
    }
}

@end
