//
//  HomeworkCommentView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HomeworkCommentView.h"

static const NSInteger kBtnTagBase = 100;

@interface HomeworkCommentView()
@property (nonatomic, strong) NSMutableArray *btnArray;
@end

@implementation HomeworkCommentView

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
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"- 评价 -";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.centerX.mas_equalTo(0);
    }];
    UIView *containerView = [[UIView alloc]init];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(14);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(240+30);
    }];
    self.btnArray = [NSMutableArray array];
    NSArray *titleArr = @[@"优秀",@"较好",@"合格",@"不合格"];
    [titleArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [self btnWithTitle:title];
        btn.tag = kBtnTagBase + idx;
        [self.btnArray addObject:btn];
        [containerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(idx*(60+10));
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(60);
        }];
    }];
    UIButton *confirmBtn = [[UIButton alloc]init];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0068bd"]] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    confirmBtn.layer.cornerRadius = 6;
    confirmBtn.clipsToBounds = YES;
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(-15);
        make.height.mas_equalTo(39);
    }];
}

- (UIButton *)btnWithTitle:(NSString *)title {
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.layer.cornerRadius = 13;
    btn.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    btn.clipsToBounds = YES;
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"fd763b"]] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    for (UIButton *btn in self.btnArray) {
        btn.selected = NO;
        btn.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    }
    sender.selected = YES;
    sender.layer.borderColor = [UIColor colorWithHexString:@"fd763b"].CGColor;
}

- (void)confirmAction {
    
}

@end
