//
//  HomeworkDetailHeaderView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HomeworkDetailHeaderView.h"
#import "GetHomeworkRequest.h"

@interface HomeworkDetailHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *rateLabel;
@end

@implementation HomeworkDetailHeaderView

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
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(22);
    }];
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.font = [UIFont systemFontOfSize:13];
    self.descLabel.textColor = [UIColor whiteColor];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel.numberOfLines = 2;
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.titleLabel.mas_right);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
    }];
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.12];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"539dd3"];
    [bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(1, 13));
    }];
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.font = [UIFont systemFontOfSize:14];
    self.countLabel.textColor = [UIColor colorWithHexString:@"99d5fe"];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(line.mas_left);
    }];
    self.rateLabel = [self.countLabel clone];
    [bottomView addSubview:self.rateLabel];
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(line.mas_right);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction)];
    [self addGestureRecognizer:tap];
    
    // mock mock
    self.titleLabel.text = @"作业详情标题";
    NSString *desc = @"作业描述作业描述作业描述作业描述作业描述作业描述作业描述作业描述作业描述作业描述作业描述";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.4f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:desc];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, desc.length)];
    self.descLabel.attributedText = attributedString;
    NSString *count = [NSString stringWithFormat:@"%@/%@",@(2),@(30)];
    NSString *complete = [NSString stringWithFormat:@"提交人数：%@",count];
    NSRange range = [complete rangeOfString:count];
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:complete];
    [attrStr addAttributes:dic range:range];
    self.countLabel.attributedText = attrStr;
    
    NSString *percent = [NSString stringWithFormat:@"%.0f%@",0.12*100,@"%"];
    NSString *rate = [NSString stringWithFormat:@"提交率：%@",percent];
    range = [rate rangeOfString:percent];
    attrStr = [[NSMutableAttributedString alloc]initWithString:rate];
    [attrStr addAttributes:dic range:range];
    self.rateLabel.attributedText = attrStr;
}

- (void)clickAction {
    BLOCK_EXEC(self.clickBlock);
}

-(void)setData:(GetHomeworkRequestItem_data *)data {
    _data = data;
    self.titleLabel.text = data.title;
    NSString *desc = data.desc;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.4f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:desc];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, desc.length)];
    self.descLabel.attributedText = attributedString;
    NSString *count = [NSString stringWithFormat:@"%@/%@",data.finishUserNum,data.totalUserNum];
    NSString *complete = [NSString stringWithFormat:@"提交人数：%@",count];
    NSRange range = [complete rangeOfString:count];
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:complete];
    [attrStr addAttributes:dic range:range];
    self.countLabel.attributedText = attrStr;
    
    NSString *percent = [NSString stringWithFormat:@"%.0f%@",[data.finishPercent floatValue]*100,@"%"];
    NSString *rate = [NSString stringWithFormat:@"提交率：%@",percent];
    range = [rate rangeOfString:percent];
    attrStr = [[NSMutableAttributedString alloc]initWithString:rate];
    [attrStr addAttributes:dic range:range];
    self.rateLabel.attributedText = attrStr;
}
@end
