//
//  ProjectAreaDistributingCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ProjectAreaDistributingCell.h"
#import <JHChart/JHColumnChart.h>
#import "AreaManager.h"

@interface ProjectAreaDistributingCell ()<JHColumnChartDelegate>
@property (nonatomic, strong) JHColumnChart *column;
@property (nonatomic, strong) UILabel *emptyLabel;
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
    column.delegate = self;

    [self.contentView addSubview:column];
    self.column = column;
    
    self.emptyLabel = [[UILabel alloc]init];
    self.emptyLabel.text = @"无数据";
    self.emptyLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.emptyLabel];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];

//    [self setupMock];
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

- (void)setDataArray:(NSArray<GetSummaryRequestItem_projectStatisticInfo *> *)dataArray {
    _dataArray = dataArray;
    NSMutableArray *valueArr = [NSMutableArray array];
    for (GetSummaryRequestItem_projectStatisticInfo *info in dataArray) {
        [valueArr addObject:@[@(info.projectNum.integerValue)]];
    }
    NSMutableArray *textArr = [NSMutableArray array];
    if ([self.groupByType isEqualToString:@"2"]) {
        for (GetSummaryRequestItem_projectStatisticInfo *info in dataArray) {
            for (Area *area in [AreaManager sharedInstance].areaModel.data) {
                if (info.provinceId.integerValue == area.areaID.integerValue) {
                    [textArr addObject:area.name];
                    break;
                }
            }
        }
    }else if ([self.groupByType isEqualToString:@"3"]) {
        NSMutableArray<Area *> *provinceArray = [NSMutableArray array];
        for (GetSummaryRequestItem_projectStatisticInfo *info in dataArray) {
            for (Area *area in [AreaManager sharedInstance].areaModel.data) {
                if (info.provinceId.integerValue == area.areaID.integerValue) {
                    [provinceArray addObject:area];
                    break;
                }
            }
        }
        [dataArray enumerateObjectsUsingBlock:^(GetSummaryRequestItem_projectStatisticInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (Area *area in provinceArray[idx].sub) {
                if (obj.cityId.integerValue == area.areaID.integerValue) {
                    [textArr addObject:area.name];
                    break;
                }
            }
        }];
    }else if ([self.groupByType isEqualToString:@"4"]) {
        NSMutableArray<Area *> *provinceArray = [NSMutableArray array];
        for (GetSummaryRequestItem_projectStatisticInfo *info in dataArray) {
            for (Area *area in [AreaManager sharedInstance].areaModel.data) {
                if (info.provinceId.integerValue == area.areaID.integerValue) {
                    [provinceArray addObject:area];
                    break;
                }
            }
        }
        NSMutableArray<Area *> *cityArray = [NSMutableArray array];
        [dataArray enumerateObjectsUsingBlock:^(GetSummaryRequestItem_projectStatisticInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (Area *area in provinceArray[idx].sub) {
                if (obj.cityId.integerValue == area.areaID.integerValue) {
                    [cityArray addObject:area];
                    break;
                }
            }
        }];
        [dataArray enumerateObjectsUsingBlock:^(GetSummaryRequestItem_projectStatisticInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (Area *area in cityArray[idx].sub) {
                if (obj.districtId.integerValue == area.areaID.integerValue) {
                    [textArr addObject:area.name];
                    break;
                }
            }
        }];
    }
    
    self.column.valueArr = valueArr;
    self.column.xShowInfoText = textArr;
    self.column.columnBGcolorsArr = @[[UIColor colorWithHexString:@"0068bd"]];
    if (valueArr.count == 0) {
        self.emptyLabel.hidden = NO;
        self.column.hidden = YES;
    }else {
        self.emptyLabel.hidden = YES;
        self.column.hidden = NO;
        [self.column showAnimation];
    }
}
- (void)columnChart:(JHColumnChart *)chart columnItem:(UIView *)item didClickAtIndexRow:(NSIndexPath *)indexPath {
    GetSummaryRequestItem_projectStatisticInfo *data = self.dataArray[indexPath.section];
    if ([self.groupByType isEqualToString:@"2"]) {
        BLOCK_EXEC(self.searchProjectBlock,data.provinceId,nil,nil);
    }else if ([self.groupByType isEqualToString:@"3"]) {
       BLOCK_EXEC(self.searchProjectBlock,data.provinceId,data.cityId,nil);
    }else if ([self.groupByType isEqualToString:@"4"]) {
       BLOCK_EXEC(self.searchProjectBlock,data.provinceId,data.cityId,data.districtId);
    }
}
@end
