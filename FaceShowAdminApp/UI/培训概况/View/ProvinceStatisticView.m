//
//  ProvinceStatisticView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ProvinceStatisticView.h"
#import "NameNumberView.h"

@interface ProvinceStatisticView()
@property (nonatomic, strong) UILabel *provinceLabel;
@property (nonatomic, strong) NameNumberView *projectView;
@property (nonatomic, strong) NameNumberView *classView;
@property (nonatomic, strong) NameNumberView *studentView;
@property (nonatomic, strong) NameNumberView *placeView;
@property (nonatomic, strong) NameNumberView *areaView;
@property (nonatomic, strong) NameNumberView *appUsedView;
@end

@implementation ProvinceStatisticView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"蓝色背景"]];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.12];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.provinceLabel = [[UILabel alloc]init];
    self.provinceLabel.font = [UIFont boldSystemFontOfSize:14];
    self.provinceLabel.textColor = [UIColor whiteColor];
    self.provinceLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:self.provinceLabel];
    [self.provinceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    self.projectView = [[NameNumberView alloc]init];
    self.projectView.name = @"项目总数";
    [self addSubview:self.projectView];
    [self.projectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).mas_offset(24);
        make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(1.0/3.0);
    }];
    self.classView = [[NameNumberView alloc]init];
    self.classView.name = @"班级总数";
    [self addSubview:self.classView];
    [self.classView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.projectView.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    self.studentView = [[NameNumberView alloc]init];
    self.studentView.name = @"学员数";
    [self addSubview:self.studentView];
    [self.studentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.projectView.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(5.0/3.0);
    }];
    self.placeView = [[NameNumberView alloc]init];
    self.placeView.name = @"班主任数量";
    [self addSubview:self.placeView];
    [self.placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.projectView.mas_bottom).mas_offset(28);
        make.centerX.mas_equalTo(self.projectView.mas_centerX);
    }];
    self.areaView = [[NameNumberView alloc]init];
    self.areaView.name = @"课程数量";
    [self addSubview:self.areaView];
    [self.areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.placeView.mas_top);
        make.centerX.mas_equalTo(self.classView.mas_centerX);
    }];
    
    self.appUsedView = [[NameNumberView alloc]init];
    self.appUsedView.name = @"App使用";
    [self addSubview:self.appUsedView];
    [self.appUsedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.placeView.mas_top);
        make.centerX.mas_equalTo(self.studentView.mas_centerX);
    }];
}

- (void)setData:(GetSummaryRequestItem_platformStatisticInfo *)data {
    _data = data;
    self.projectView.number = data.projectNum;
    self.classView.number = data.clazsNum;
    self.studentView.number = data.studentNum;
    self.placeView.number = data.teacherNum;
    self.areaView.number = data.courseNum;
    self.appUsedView.number = @"100/356";//data.app使用
}

- (void)updateWithPtocince:(Area *)province city:(Area *)city district:(Area *)district {
    if (!province) {
        self.provinceLabel.text = @"全部";
    }else {
        NSString *title = province.name;
        if (city) {
            title = [title stringByAppendingString:@"-"];
            title = [title stringByAppendingString:city.name];
        }
        if (district) {
            title = [title stringByAppendingString:@"-"];
            title = [title stringByAppendingString:district.name];
        }
        self.provinceLabel.text = title;
    }
}
@end
