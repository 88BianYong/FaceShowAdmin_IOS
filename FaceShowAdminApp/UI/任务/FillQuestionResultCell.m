//
//  FillQuestionResultCell.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FillQuestionResultCell.h"

@interface FillQuestionResultCell()
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *stemLabel;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIButton *replyButton;
@end

@implementation FillQuestionResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    self.indexLabel = [[UILabel alloc]init];
    self.indexLabel.font = [UIFont boldSystemFontOfSize:14];
    self.indexLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(25);
    }];
    
    self.stemLabel = [[UILabel alloc]init];
    self.stemLabel.font = [UIFont boldSystemFontOfSize:14];
    self.stemLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.stemLabel.numberOfLines = 0;
    [self.contentView addSubview:self.stemLabel];
    [self.stemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.indexLabel.mas_right);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(25);
    }];
    
    self.replyButton = [[UIButton alloc]init];
    [self.replyButton setTitle:@"查看回复" forState:UIControlStateNormal];
    [self.replyButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [self.replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.replyButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"b3b7b9"]] forState:UIControlStateHighlighted];
    self.replyButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.replyButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    self.replyButton.layer.cornerRadius = 6;
    self.replyButton.layer.borderColor = [UIColor colorWithHexString:@"b3b7b9"].CGColor;
    self.replyButton.layer.borderWidth = 2;
    self.replyButton.clipsToBounds = YES;
    [self.contentView addSubview:self.replyButton];
    [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stemLabel.mas_bottom).mas_offset(20);
        make.bottom.mas_equalTo(-25);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    
    [self.indexLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.indexLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.stemLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.stemLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)btnAction {
    BLOCK_EXEC(self.showReplyBlock);
}

- (void)setBottomLineHidden:(BOOL)bottomLineHidden {
    _bottomLineHidden = bottomLineHidden;
    self.bottomLineView.hidden = bottomLineHidden;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    NSString *indexStr = [NSString stringWithFormat:@"%@、",@(index)];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:indexStr attributes:dic];
    self.indexLabel.attributedText = attributeStr;
}

- (void)setItem:(QuestionRequestItem_question *)item {
    _item = item;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    NSString *stem = self.item.title;
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:stem attributes:dic];
    self.stemLabel.attributedText = attributeStr;
}


@end
