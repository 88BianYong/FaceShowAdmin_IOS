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
    JHPieChart *pie = [[JHPieChart alloc] initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH-40, 320)];
    pie.backgroundColor = [UIColor whiteColor];
    pie.didClickType = JHPieChartDidClickTranslateToBig;
    pie.animationDuration = 0.5;
    pie.positionChangeLengthWhenClick = 15;
    pie.showDescripotion = YES;
    pie.animationType = JHPieChartAnimationByOrder;
    [self.contentView addSubview:pie];
    self.pie = pie;
    
    [self setupMock];
}

- (void)setupMock {
    /* Pie chart value, will automatically according to the percentage of numerical calculation */
    self.pie.valueArr = @[@18,@14,@25,@40,@18];
    /* The description of each sector must be filled, and the number must be the same as the pie chart. */
    self.pie.descArr = @[@"第一个元素",@"第二个元素",@"第三个元素",@"第四个元素",@"5"];
    self.pie.colorArr = @[[UIColor colorWithHexString:@"21c7dc"],
                          [UIColor colorWithHexString:@"59afe7"],
                          [UIColor colorWithHexString:@"ccf1fc"],
                          [UIColor colorWithHexString:@"83d6f1"],
                          [UIColor colorWithHexString:@"25b7fc"]];
    [self.pie showAnimation];
}

@end
