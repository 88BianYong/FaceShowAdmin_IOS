//
//  ProjectAreaDistributingCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ProjectAreaDistributingCell.h"
#import <JHChart/JHColumnChart.h>

@interface ProjectAreaDistributingCell ()
@property (nonatomic, strong) JHColumnChart *column;
@end

@implementation ProjectAreaDistributingCell

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
    JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 300)];
    /*       This point represents the distance from the lower left corner of the origin.         */
    column.originSize = CGPointMake(30, 20);
    /*    The first column of the distance from the starting point     */
    column.drawFromOriginX = 0;
    column.backgroundColor = [UIColor whiteColor];
    column.typeSpace = 30;
    column.isShowYLine = NO;
    column.contentInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    /*        Column width         */
    column.columnWidth = 30;
    /*        Column backgroundColor         */
    column.bgVewBackgoundColor = [UIColor whiteColor];
    /*        X, Y axis font color         */
    column.drawTextColorForX_Y = [UIColor blackColor];
    /*        X, Y axis line color         */
    column.colorForXYLine = [UIColor darkGrayColor];
    column.isShowLineChart = NO;

    [self.contentView addSubview:column];
    self.column = column;
    
    [self setupMock];
}

- (void)setupMock {
    self.column.valueArr = @[
                        @[@15],//第一组元素 如果有多个元素，往该组添加，每一组只有一个元素，表示是单列柱状图| | | | |
                        @[@15],//第二组元素
                        @[@10],//第三组元素
                        @[@21],
                        @[@19],
                        @[@12],
                        @[@15],
                        @[@9],
                        @[@8],
                        @[@6],
                        @[@9],
                        @[@18],
                        @[@11],
                        ];
    /*    Each module of the color array, such as the A class of the language performance of the color is red, the color of the math achievement is green     */
    self.column.columnBGcolorsArr = @[[UIColor colorWithHexString:@"0068bd"]];//如果为复合型柱状图 即每个柱状图分段 需要传入如上颜色数组 达到同时指定复合型柱状图分段颜色的效果
    /*        Module prompt         */
    self.column.xShowInfoText = @[@"A班级",@"B班级",@"C班级",@"D班级",@"E班级",@"F班级",@"G班级",@"H班级",@"i班级",@"J班级",@"L班级",@"M班级",@"N班级"];
    [self.column showAnimation];
}

@end
