//
//  CustomTimeSettingView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CustomTimeSettingView.h"
#import "SignInDateTimeView.h"
#import "SignInDateTimeSettingView.h"
#import "AlertView.h"

@interface CustomTimeSettingView()
@property (nonatomic, strong) SignInDateTimeView *begintimeView;
@property (nonatomic, strong) SignInDateTimeView *endtimeView;
@property (nonatomic, strong) AlertView *alertView;
@end

@implementation CustomTimeSettingView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.begintimeView = [[SignInDateTimeView alloc]init];
    self.begintimeView.title = @"开始时间";
    WEAK_SELF
    [self.begintimeView setSelectionBlock:^{
        STRONG_SELF
        [self showSelectionViewFrom:self.begintimeView];
    }];
    [self addSubview:self.begintimeView];
    [self.begintimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(18);
        make.height.mas_equalTo(50);
    }];
    UIView *v1 = [[UIView alloc]init];
    v1.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:v1];
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.begintimeView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    self.endtimeView = [[SignInDateTimeView alloc]init];
    self.endtimeView.title = @"结束时间";
    [self.endtimeView setSelectionBlock:^{
        STRONG_SELF
        [self showSelectionViewFrom:self.endtimeView];
    }];
    [self addSubview:self.endtimeView];
    [self.endtimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(v1.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    UIView *v2 = [v1 clone];
    [self addSubview:v2];
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.endtimeView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

- (void)showSelectionViewFrom:(SignInDateTimeView *)from {
    SignInDateTimeSettingView *settingView = [[SignInDateTimeSettingView alloc]init];
    settingView.mode = UIDatePickerModeDate;
    if (from == self.begintimeView) {
        settingView.date = self.beginDate;
    }else if (from == self.endtimeView) {
        settingView.date = self.endDate;
    }
    WEAK_SELF
    [settingView setCancelBlock:^{
        STRONG_SELF
        [self.alertView hide];
    }];
    [settingView setConfirmBlock:^(NSString *result,NSDate *date){
        STRONG_SELF
        from.content = result;
        [self.alertView hide];
        if (from == self.begintimeView) {
            self.beginDate = date;
        }else if (from == self.endtimeView) {
            self.endDate = date;
        }
    }];
    self.alertView = [[AlertView alloc]init];
    self.alertView.contentView = settingView;
    self.alertView.hideWhenMaskClicked = YES;
    [self.alertView showWithLayout:^(AlertView *view) {
        view.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        [UIView animateWithDuration:0.3 animations:^{
            view.contentView.frame = CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 250);
        }];
    }];
}

- (NSString *)startTime {
    return [self.begintimeView.content stringByReplacingOccurrencesOfString:@"." withString:@"-"];
}
- (NSString *)endTime {
    return [self.endtimeView.content stringByReplacingOccurrencesOfString:@"." withString:@"-"];
}
@end
