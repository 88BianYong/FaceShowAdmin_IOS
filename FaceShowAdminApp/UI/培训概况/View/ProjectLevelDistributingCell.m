//
//  ProjectLevelDistributingCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ProjectLevelDistributingCell.h"
#import <JHChart/JHPieChart.h>

@interface ProjectLevelDistributingCell ()
@property (nonatomic, strong) JHPieChart *pie;
@property (nonatomic, strong) UILabel *emptyLabel;
@end

@implementation ProjectLevelDistributingCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.emptyLabel = [[UILabel alloc]init];
    self.emptyLabel.text = @"无数据";
    self.emptyLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.emptyLabel];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)setDataArray:(NSArray<GetSummaryRequestItem_projectStatisticInfo *> *)dataArray {
    [self.pie removeFromSuperview];
    JHPieChart *pie = [[JHPieChart alloc] initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH-40, 320)];
    pie.backgroundColor = [UIColor whiteColor];
    pie.didClickType = JHPieChartDidClickTranslateToBig;
    pie.animationDuration = 0.5;
    pie.positionChangeLengthWhenClick = 0;
    pie.showDescripotion = YES;
    pie.animationType = JHPieChartAnimationByOrder;
    [self.contentView addSubview:pie];
    self.pie = pie;
    WEAK_SELF
    self.pie.chooseSelectedBlock = ^(NSInteger integer) {
        STRONG_SELF
        GetSummaryRequestItem_projectStatisticInfo *data = dataArray[integer];
        if (self.isTypeBool) {
             BLOCK_EXEC(self.searchProjectBlock,data.projectType);
        }else {
             BLOCK_EXEC(self.searchProjectBlock,data.projectLevel);
        }
    };
    
    NSMutableArray *valueArr = [NSMutableArray array];
    NSMutableArray *descArr = [NSMutableArray array];
    for (GetSummaryRequestItem_projectStatisticInfo *info in dataArray) {
        [valueArr addObject:@(info.projectNum.integerValue)];
        if (self.isTypeBool) {
            [descArr addObject:info.projectTypeName?:@""];
        }else {
            [descArr addObject:info.projectLevelName?:@""];
        }
    }
    
    self.pie.valueArr = valueArr;
    self.pie.descArr = descArr;
    self.pie.colorArr = @[[UIColor colorWithHexString:@"3da6f0"],
                          [UIColor colorWithHexString:@"1add96"],
                          [UIColor colorWithHexString:@"f0d53d"],
                          [UIColor colorWithHexString:@"b85ef1"],
                          [UIColor colorWithHexString:@"f26d86"]];
    if (valueArr.count == 0) {
        self.emptyLabel.hidden = NO;
        self.pie.hidden = YES;
    }else {
        self.emptyLabel.hidden = YES;
        self.pie.hidden = NO;
        [self.pie showAnimation];
    }
}

@end
