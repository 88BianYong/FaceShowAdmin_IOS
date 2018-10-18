//
//  MultipleSignDateSelectView.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MultipleSignDateSelectView.h"
#import "SignInDateTimeView.h"

@interface MultipleSignDateSelectView()
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *startStr;
@property (nonatomic, copy) NSString *endStr;
@property (nonatomic, strong) SignInDateTimeView *startDate;
@property (nonatomic, strong) SignInDateTimeView *endDate;
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation MultipleSignDateSelectView

- (instancetype)initWithSelectTitle:(NSString *)title startString:(NSString *)startStr endString:(NSString *)endStr{
    self = [super init];
    if (self) {
        _title = title;
        _startStr = startStr;
        _endStr = endStr;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = _title;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
    }];

    self.deleteButton = [[UIButton alloc] init];
    [self.deleteButton setImage:[UIImage imageNamed:@"聊聊-删除按钮正常态"] forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"聊聊-删除按钮点击态"] forState:UIControlStateHighlighted];
    [self.deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];


    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"dce0e3"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.deleteButton.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    WEAK_SELF
    self.startDate = [[SignInDateTimeView alloc] init];
    [self.startDate setTitle:_startStr];
    [self addSubview:self.startDate];
    [self.startDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.startDate.selectionBlock = ^{
        STRONG_SELF
        BLOCK_EXEC(self.selectDateBlock,0);
    };

    UIView *line2 = [line clone];
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.startDate.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    self.endDate = [[SignInDateTimeView alloc] init];
    [self.endDate setTitle:_endStr];
    [self addSubview:self.endDate];
    [self.endDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom).offset(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    self.endDate.selectionBlock = ^{
        STRONG_SELF
        BLOCK_EXEC(self.selectDateBlock,1);
    };

}

- (void)setType:(SignDateSelectTypeMode)type{
    _type = type;
    [self.deleteButton setHidden:!type];
}

- (void)setSelectDate:(NSString *)dateStr atRow:(NSInteger)row{
    switch (row) {
        case 0:
        {
            [self.startDate setContent:dateStr];
            _startStr = dateStr;
        }
            break;
        case 1:
        {
            [self.endDate setContent:dateStr];
            _endStr = dateStr;
        }
            break;
        default:
            break;
    }
    [self refreshSubmitted];
}

- (BOOL)buttonEnabled{
    return !(isEmpty(self.startDate.content) || isEmpty(self.endDate.content));
}

- (NSString *)canBeSubmitted{
    return [self refreshSubmitted];
}

- (NSString *)refreshSubmitted{
    if (isEmpty(self.startDate.content)){
        if (_type == SignDateSelectTypeMode_Date) {
            return @"起始日期为空";
        }else{
            return @"起始时间为空";
        }
    }else if(isEmpty(self.endDate.content)){
        if (_type == SignDateSelectTypeMode_Date) {
            return @"结束日期为空";
        }else{
            return @"结束时间为空";
        }
    }else {
        if (_type == SignDateSelectTypeMode_Date) {
            int i = [self.startDate.content isAscendingCompareTimeDate:self.endDate.content];
            if (i < 1) {
                return @"结束日期必须大于开始日期";
            }else{
                return nil;
            }
        }else{
            int i = [self.startDate.content isAscendingCompareTime:self.endDate.content];
            if (i < 1) {
                return @"结束时间必须大于开始时间";
            }else{
                return nil;
            }

        }
    }
}

- (void)deleteAction{
    BLOCK_EXEC(self.deleteBlock);
}

- (NSDictionary *)signTimeDic{
    return @{
             @"signInTimeStart":self.startStr,
             @"signInTimeEnd":self.endStr
             };
}

@end
