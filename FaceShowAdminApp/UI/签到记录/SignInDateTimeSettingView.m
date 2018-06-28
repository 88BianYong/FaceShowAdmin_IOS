//
//  SignInDateTimeSettingView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInDateTimeSettingView.h"

@interface SignInDateTimeSettingView()
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation SignInDateTimeSettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    UIView *menuView = [[UIView alloc]init];
    [self addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    self.confirmButton = [[UIButton alloc]init];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(40);
    }];
    self.cancelButton = [self.confirmButton clone];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(40);
    }];
    UIView *sep = [[UIView alloc]init];
    sep.backgroundColor = [UIColor colorWithHexString:@"dce0e3"];
    [self addSubview:sep];
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(menuView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.datePicker = [[UIDatePicker alloc]init];
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(sep.mas_bottom);
    }];
}

- (void)confirmAction {
    NSDate *date = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    if (self.mode == UIDatePickerModeDate) {
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    }else {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    NSString  *string = [[NSString alloc]init];
    string = [dateFormatter stringFromDate:date];
    BLOCK_EXEC(self.confirmBlock,string,date);
}

- (void)cancelAction {
    BLOCK_EXEC(self.cancelBlock);
}

- (void)setMode:(UIDatePickerMode)mode {
    _mode = mode;
    self.datePicker.datePickerMode = mode;
}
- (void)setDate:(NSDate *)date {
    _date = date;
    if (date) {
        self.datePicker.date = date;
    }
}
@end
