//
//  TaskListCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TaskListCell.h"
#import "FSDataMappingTable.h"

@interface TaskListCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *completionLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation TaskListCell

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

    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(17);
        make.right.mas_equalTo(-50);
    }];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.font = [UIFont systemFontOfSize:12];
    self.descLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(6);
        make.right.mas_equalTo(self.titleLabel.mas_right);
    }];
    
    self.completionLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.completionLabel];
    self.completionLabel.font = [UIFont boldSystemFontOfSize:14];
    self.completionLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
    [self.completionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setLineHidden:(BOOL)lineHidden {
    _lineHidden = lineHidden;
    self.line.hidden = lineHidden;
}

- (void)setData:(GetAllTasksRequestItem_task *)data {
    _data = data;
    self.titleLabel.text = data.interactName;
    if (data.courseName.length <= 0) {
        data.courseName = @"班级任务";
    }
    self.descLabel.text = [NSString stringWithFormat:@"所属课程:%@",data.courseName];
    InteractType type = [FSDataMappingTable InteractTypeWithKey:data.interactType];
    if (type == InteractType_Comment) {
        self.completionLabel.text = data.finishedStudentNum;
    }else {
        NSString *count = [NSString stringWithFormat:@"%@/%@",data.finishedStudentNum,data.totalStudentNum];
        self.completionLabel.text = count;
    }
}

@end
