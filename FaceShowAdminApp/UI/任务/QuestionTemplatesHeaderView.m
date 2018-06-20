//
//  QuestionTemplatesHeaderView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "QuestionTemplatesHeaderView.h"
@interface QuestionTemplatesHeaderView ()
@property (nonatomic, strong) UILabel *questionLabel;
@end
@implementation QuestionTemplatesHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.frame = [UIScreen mainScreen].bounds;
        [self layoutIfNeeded];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.questionLabel = [[UILabel alloc] init];
    self.questionLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.questionLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.questionLabel.numberOfLines = 0;
    [self.contentView addSubview:self.questionLabel];
}
- (void)setupLayout {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
    }];
}
- (void)reloadTemplate:(NSString *)title withIndex:(NSInteger)index withType:(NSInteger)type {
    NSString *typeString = @"单选";
    if (type == 2){
        typeString = @"多选";
    }else if (type == 3) {
        typeString = @"开发题";
    }
    NSString *contentString = [NSString stringWithFormat:@"%ld、%@(%@)",(long)index,title,typeString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSAttributedString *attributedString  = [[NSAttributedString alloc] initWithString:contentString attributes:@{NSParagraphStyleAttributeName :paragraphStyle}];
    self.questionLabel.attributedText = attributedString;
}

@end
