//
//  QuestionTemplatesTableHeaderView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "QuestionTemplatesTableHeaderView.h"
@interface QuestionTemplatesTableHeaderView()
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentLabel;
@end
@implementation QuestionTemplatesTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.titleView = [[UIView alloc] init];
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.titleView addSubview:self.titleLabel];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.contentLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:self.contentLabel];
    
}
- (void)setupLayout {
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(5.0f);
        make.height.mas_offset(56.0f).priorityLow();
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleView.mas_left).offset(15.0f).priorityLow();
        make.right.equalTo(self.titleView.mas_right).offset(-15.0f).priorityLow();
        make.centerY.equalTo(self.titleView.mas_centerY);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.titleView.mas_bottom).offset(5.0f);
        make.bottom.equalTo(self.mas_bottom).offset(-5.0f);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f).priorityLow();
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f).priorityLow();
        make.top.equalTo(self.contentView.mas_top).offset(15.0f).priorityLow();
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f).priorityLow();
    }];
}
- (void)reloadQuestionTemplateTitle:(NSString *)title withTemplateContent:(NSString *)content {
    self.titleLabel.text = title;
    self.contentLabel.text = content;
}
+ (CGFloat)calculateHeightBasedContent:(NSString *)content {
    CGRect rect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30.0f, 999.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
    return rect.size.height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
