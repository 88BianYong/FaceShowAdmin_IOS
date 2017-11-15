//
//  SignInDelayView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SignInDelayView.h"

@interface SignInDelayView()
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation SignInDelayView

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
    [self.confirmButton setTitle:@"提交补签" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(80);
    }];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [menuView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
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
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(sep.mas_bottom);
    }];
}

- (void)confirmAction {
    NSDate *date = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString  *string = [[NSString alloc]init];
    string = [dateFormatter stringFromDate:date];
    BLOCK_EXEC(self.confirmBlock,string);
}

- (void)setName:(NSString *)name {
    _name = name;
    NSString *complete = [NSString stringWithFormat:@"补签成员：%@",name];
    NSRange range = [complete rangeOfString:name];
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:complete];
    [attrStr addAttributes:dic range:range];
    self.nameLabel.attributedText = attrStr;
}

@end
