//
//  QuestionnaireHeaderView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QuestionnaireHeaderView.h"
#import "FSDataMappingTable.h"

@interface QuestionnaireHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation QuestionnaireHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"投票详情问卷详情头部背景"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 2;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25).priorityHigh();
        make.right.mas_equalTo(-25).priorityHigh();
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(77);
    }];
    UIButton *detailButton = [[UIButton alloc]init];
    [detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [detailButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [detailButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateHighlighted];
    [detailButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    detailButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [detailButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    detailButton.layer.cornerRadius = 6;
    detailButton.layer.borderColor = [UIColor whiteColor].CGColor;
    detailButton.layer.borderWidth = 1;
    detailButton.clipsToBounds = YES;
    [self addSubview:detailButton];
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(80, 26));
    }];
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.font = [UIFont systemFontOfSize:14];
    self.countLabel.textColor = [UIColor colorWithHexString:@"99d5fe"];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(detailButton.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(0);
    }];
}

- (void)btnAction {
    BLOCK_EXEC(self.detailBlock);
}

- (void)setData:(QuestionRequestItem_data *)data {
    _data = data;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    paraStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSString *project = data.questionGroup.title;
    NSAttributedString *projectAttributeStr = [[NSAttributedString alloc] initWithString:project attributes:dic];
    self.titleLabel.attributedText = projectAttributeStr;

    NSString *count = [NSString stringWithFormat:@"%@/%@",data.questionGroup.answerUserNum,data.questionGroup.totalUserNum];
    NSString *complete = @"";
    InteractType type = [FSDataMappingTable InteractTypeWithKey:data.interactType];
    if (type == InteractType_Vote) {
        complete = [NSString stringWithFormat:@"投票人数：%@",count];
    } else if (type == InteractType_Questionare) {
        complete = [NSString stringWithFormat:@"提交人数：%@",count];
    } else if (type == InteractType_Evaluate) {
        complete = [NSString stringWithFormat:@"提交人数：%@",count];
    }
    NSRange range = [complete rangeOfString:count];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:complete];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ffffff"] range:range];
    self.countLabel.attributedText = attr;
}

@end
