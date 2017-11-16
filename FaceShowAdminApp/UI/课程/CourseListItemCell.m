//
//  CourseListItemCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseListItemCell.h"
#import "FSDataMappingTable.h"

@interface CourseListItemCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *teacherLabel;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UIView *signInContainerView;
@property (nonatomic, strong) UILabel *placeTagLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation CourseListItemCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    }else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *topLine = [[UIView alloc]init];
    self.line = topLine;
    topLine.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
    }];
    UILabel *timeTagLabel = [[UILabel alloc]init];
    timeTagLabel.font = [UIFont systemFontOfSize:11];
    timeTagLabel.textColor = [UIColor whiteColor];
    timeTagLabel.textAlignment = NSTextAlignmentCenter;
    timeTagLabel.backgroundColor = [UIColor colorWithHexString:@"979fad"];
    timeTagLabel.text = @"时间";
    timeTagLabel.layer.cornerRadius = 3;
    timeTagLabel.clipsToBounds = YES;
    [self.contentView addSubview:timeTagLabel];
    [timeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(19);
        make.size.mas_equalTo(CGSizeMake(34, 15));
    }];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeTagLabel.mas_right).mas_offset(10);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(timeTagLabel.mas_centerY);
    }];
    UILabel *teacherTagLabel = [timeTagLabel clone];
    teacherTagLabel.text = @"讲师";
    [self.contentView addSubview:teacherTagLabel];
    [teacherTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeTagLabel.mas_left);
        make.top.mas_equalTo(timeTagLabel.mas_bottom).mas_offset(9);
        make.size.mas_equalTo(CGSizeMake(34, 15));
    }];
    self.teacherLabel = [self.timeLabel clone];
    [self.contentView addSubview:self.teacherLabel];
    [self.teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(teacherTagLabel.mas_right).mas_offset(10);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(teacherTagLabel.mas_centerY);
    }];
    UILabel *placeTagLabel = [timeTagLabel clone];
    self.placeTagLabel = placeTagLabel;
    placeTagLabel.text = @"地点";
    [self.contentView addSubview:placeTagLabel];
    [placeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(teacherTagLabel.mas_left);
        make.top.mas_equalTo(teacherTagLabel.mas_bottom).mas_offset(9);
        make.size.mas_equalTo(CGSizeMake(34, 15));
    }];
    self.placeLabel = [self.timeLabel clone];
    [self.contentView addSubview:self.placeLabel];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(placeTagLabel.mas_right).mas_offset(10);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(placeTagLabel.mas_centerY);
    }];
    self.signInContainerView = [[UIView alloc]init];
    [self.contentView addSubview:self.signInContainerView];
    [self.signInContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(placeTagLabel.mas_bottom).mas_offset(20);
        make.height.bottom.mas_equalTo(0);
    }];
}

- (void)setItem:(GetCourseListRequestItem_coursesList *)item {
    _item = item;
    self.titleLabel.text = item.courseName;
    NSArray *startArr = [item.startTime componentsSeparatedByString:@" "];
    NSString *startDate = startArr.firstObject;
    startDate = [startDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *startTime = startArr.lastObject;
    startTime = [startTime substringToIndex:5];
    NSArray *endArr = [item.endTime componentsSeparatedByString:@" "];
    NSString *endDate = endArr.firstObject;
    endDate = [endDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTime = endArr.lastObject;
    endTime = [endTime substringToIndex:5];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ %@",startDate,startTime,endDate,endTime];
    self.teacherLabel.text = isEmpty([self lecturesName]) ? @"暂无" : [self lecturesName];
    self.placeLabel.text = isEmpty(item.site) ? @"待定" : item.site;
    
    for (UIView *view in self.signInContainerView.subviews) {
        [view removeFromSuperview];
    }
    NSMutableArray<GetCourseListRequestItem_step *> *signIns = [NSMutableArray array];
    for (GetCourseListRequestItem_step *step in item.steps) {
        if ([FSDataMappingTable InteractTypeWithKey:step.interactType] == InteractType_SignIn) {
            [signIns addObject:step];
        }
    }
    if (signIns.count == 0) {
        [self.signInContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.placeTagLabel.mas_bottom).mas_offset(20);
            make.height.bottom.mas_equalTo(0);
        }];
    }else {
        [self.signInContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.placeTagLabel.mas_bottom).mas_offset(20);
            make.bottom.mas_equalTo(-20);
        }];
        __block UIView *preView = nil;
        [signIns enumerateObjectsUsingBlock:^(GetCourseListRequestItem_step *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *itemView = [self labelWithData:obj];
            [self.signInContainerView addSubview:itemView];
            if (idx == 0) {
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo(0);
                }];
            }else {
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(preView.mas_bottom).mas_offset(10);
                }];
            }
            if (idx == signIns.count-1) {
                [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                }];
            }
            preView = itemView;
        }];
    }
}

- (UILabel *)labelWithData:(GetCourseListRequestItem_step *)data {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"999999"];
    NSString *count = [NSString stringWithFormat:@"%@/%@",data.finishedStudentNum,data.totalStudentNum];
    NSString *complete = [NSString stringWithFormat:@"%@：%@",data.interactName,count];
    NSRange range = [complete rangeOfString:count];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:complete];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:range];
    label.attributedText = attr;
    return label;
}

- (NSString *)lecturesName {
    NSMutableString *lecturesName = [NSMutableString string];
    for (GetCourseListRequestItem_LecturerInfo *info in self.item.lecturerInfos) {
        if (!isEmpty(lecturesName)) {
            [lecturesName appendString:@","];
        }
        [lecturesName appendString:[NSString stringWithFormat:@"%@",  info.lecturerName]];
    }
    return lecturesName;
}

- (void)setShowLineFromLeft:(BOOL)showLineFromLeft {
    _showLineFromLeft = showLineFromLeft;
    CGFloat left = showLineFromLeft? 0:15;
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
    }];
}

@end
