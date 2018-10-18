//
//  MultipleSignDateView.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MultipleSignDateView.h"
#import "MultipleSignDateSelectView.h"

@interface MultipleSignDateView()
@property (nonatomic, strong) MASViewAttribute *timeSelectLastBottom;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSMutableArray<MultipleSignDateSelectView *>*selectViewArr;
@property (nonatomic, strong) MultipleSignDateSelectView *dateSelectView;
@end

@implementation MultipleSignDateView

- (NSMutableArray<MultipleSignDateSelectView *>*)selectViewArr{
    if (!_selectViewArr) {
        _selectViewArr = [NSMutableArray array];
    }
    return _selectViewArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];

    WEAK_SELF
    self.dateSelectView = [[MultipleSignDateSelectView alloc] initWithSelectTitle:@"签到日期范围" startString:@"开始日期" endString:@"结束日期"];
    self.dateSelectView.type = SignDateSelectTypeMode_Date;
    [self addSubview:self.dateSelectView];
    [self.dateSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    self.dateSelectView.selectDateBlock = ^(NSInteger index) {
        STRONG_SELF
        if (self.dateSelectBlock) {
            self.dateSelectBlock(self.dateSelectView, index);
        }
    };
    self.timeSelectLastBottom = self.dateSelectView.mas_bottom;

    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setTitle:@"添加时间" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.addButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.addButton.layer.borderColor = [UIColor colorWithHexString:@"0068bd"].CGColor;
    self.addButton.layer.borderWidth = 1.0;
    [self addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeSelectLastBottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 40));
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
    }];
    [self.addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];

    [self addAction];
}

- (void)addAction{

    MultipleSignDateSelectView *timeSelectView = [[MultipleSignDateSelectView alloc] initWithSelectTitle:@"签到时间" startString:@"开始时间" endString:@"结束时间"];
    timeSelectView.type = SignDateSelectTypeMode_Time;
    [self.selectViewArr addObject:timeSelectView];
    [self addSubview:timeSelectView];
    [timeSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeSelectLastBottom).offset(5);
        make.left.right.mas_equalTo(0);
    }];
    WEAK_SELF
    __weak typeof(timeSelectView)weakTimeSelectView = timeSelectView;
    timeSelectView.selectDateBlock = ^(NSInteger index) {
        STRONG_SELF
        __strong typeof(weakTimeSelectView)timeSelectView = weakTimeSelectView;
        if (self.dateSelectBlock) {
            self.dateSelectBlock(timeSelectView, index);
        }
    };
    timeSelectView.deleteBlock = ^{
        STRONG_SELF
        __strong typeof(weakTimeSelectView)timeSelectView = weakTimeSelectView;
        if(self.selectViewArr.count == 1){
            [[UIApplication sharedApplication].keyWindow nyx_showToast:@"必须填写至少一个时间"];
            return;
        }
        CGFloat width = timeSelectView.width;
        [UIView animateWithDuration:0.25 animations:^{
            timeSelectView.x -= width;
        } completion:^(BOOL finished) {
            timeSelectView.alpha = 0.0f;
            [timeSelectView removeFromSuperview];
            NSInteger index = [self.selectViewArr indexOfObject:timeSelectView];
            if (index == self.selectViewArr.count - 1) {
                if (index != 0) {
                    MultipleSignDateSelectView *topSelectView = [self.selectViewArr objectAtIndex:index - 1];
                    self.timeSelectLastBottom = topSelectView.mas_bottom;
                    [self updateAddButton];
                }else{
                    self.timeSelectLastBottom = self.dateSelectView.mas_bottom;
                    [self updateAddButton];
                }
            }else{
                if (index == 0) {
                    self.timeSelectLastBottom = self.dateSelectView.mas_bottom;
                    MultipleSignDateSelectView *bottomSelectView = [self.selectViewArr objectAtIndex:index + 1];
                    [bottomSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.timeSelectLastBottom).offset(5);
                        make.left.right.mas_equalTo(0);
                    }];
                }else{
                    MultipleSignDateSelectView *topSelectView = [self.selectViewArr objectAtIndex:index - 1];
                    self.timeSelectLastBottom = topSelectView.mas_bottom;
                    MultipleSignDateSelectView *bottomSelectView = [self.selectViewArr objectAtIndex:index + 1];
                    [bottomSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.timeSelectLastBottom).offset(5);
                        make.left.right.mas_equalTo(0);
                    }];
                }
            }
            [self.selectViewArr removeObject:timeSelectView];
        }];
    };
    self.timeSelectLastBottom = timeSelectView.mas_bottom;
    [self updateAddButton];
}

- (void)updateAddButton{
    [self.addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeSelectLastBottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 40));
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
    }];

}

- (NSString *)signInTimeSetting{
    NSMutableDictionary *setting = [NSMutableDictionary dictionaryWithDictionary:[self transfromTimeDict:self.dateSelectView.signTimeDic]];
    NSMutableArray *timeArr = [NSMutableArray array];
    for (MultipleSignDateSelectView *selectView in self.selectViewArr) {
        [timeArr addObject:selectView.signTimeDic];
    }
    [setting setValue:timeArr forKey:@"signInTimes"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:setting options:NSJSONWritingPrettyPrinted error:nil];
    NSString *signInTimeSetting = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return signInTimeSetting;
}

- (NSDictionary *)transfromTimeDict:(NSDictionary *)timeDict{
    return @{
             @"signInDateStart":timeDict[@"signInTimeStart"],
             @"signInDateEnd":timeDict[@"signInTimeEnd"]
             };
}

- (NSString *)canBeSubmitted{
    NSString *error;
    for (UIView *selectView in self.subviews) {
        if ([selectView isKindOfClass:[MultipleSignDateSelectView class]]) {
            MultipleSignDateSelectView *select = (MultipleSignDateSelectView *)selectView;
            error = select.canBeSubmitted;
            if (!isEmpty(error)) {
                break;
            }
        }
    }
    return error;
}

- (BOOL)buttonEnabled{
    for (UIView *selectView in self.subviews) {
        if ([selectView isKindOfClass:[MultipleSignDateSelectView class]]) {
            MultipleSignDateSelectView *select = (MultipleSignDateSelectView *)selectView;
            if (!select.buttonEnabled) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)setDefaultStartDate:(NSString *)startTime endDate:(NSString *)endTime{
    [self.dateSelectView setSelectDate:startTime atRow:0];
    [self.dateSelectView setSelectDate:endTime atRow:1];
    [self addAction];

    NSArray *arr = @[@[@"08:00",@"10:00"],@[@"13:00",@"15:00"]];
    [self.selectViewArr enumerateObjectsUsingBlock:^(MultipleSignDateSelectView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *timeArr = arr[idx];
        [obj setSelectDate:timeArr.firstObject atRow:0];
        [obj setSelectDate:timeArr.lastObject atRow:1];
    }];
}

@end
