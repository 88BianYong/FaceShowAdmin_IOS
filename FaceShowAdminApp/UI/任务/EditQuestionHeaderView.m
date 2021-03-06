//
//  EditQuestionHeaderView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "EditQuestionHeaderView.h"
#import "SAMTextView+Restriction.h"
@interface EditQuestionHeaderView ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomView;
@end
@implementation EditQuestionHeaderView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"keyBoardHide" object:nil] subscribeNext:^(id x) {
            STRONG_SELF
            [self.textView resignFirstResponder];
        }];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setTag:(NSInteger)tag {
    [super setTag:tag];
    self.titleLabel.text = [NSString stringWithFormat:@"问题%ld:",(long)tag];
}
#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.titleLabel.text = @"问题1:";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    
    self.textView = [[SAMTextView alloc] init];
    self.textView.font = [UIFont boldSystemFontOfSize:16.0f];
    self.textView.textColor = [UIColor colorWithHexString:@"333333"];
    self.textView.characterInteger = 20;
    self.textView.placeholder = @"请输入问题";
    self.textView.scrollEnabled = NO;
    self.textView.tag = 10001;
    self.textView.delegate = self;
    [self.contentView addSubview:self.textView];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.bottomView];
}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(17.0f);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(8.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-14.0f);
        make.height.mas_greaterThanOrEqualTo(30.0f).priorityHigh();
        make.left.equalTo(self.contentView.mas_left).offset(79.0f);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(4.0f);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
    }];
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}
@end
