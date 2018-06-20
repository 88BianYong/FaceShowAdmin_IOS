//
//  CreateComplexTableHeaderView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateComplexTableHeaderView.h"
#import "SAMTextView+Restriction.h"
#import "UITextField+Restriction.h"
@interface CreateComplexTableHeaderView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *lineView;


@end
@implementation CreateComplexTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.courseView = [[TaskChooseContentView alloc] init];
    self.courseView.nameString = @"所属课程";
    self.courseView.chooseContentString = [UserManager sharedInstance].userModel.currentClass.clazsName;
    [self addSubview:self.courseView];
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    
    self.textField = [[UITextField alloc] init];
    self.textField.characterInteger = 20;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.textColor = [UIColor colorWithHexString:@"333333"];
    self.textField.font = [UIFont boldSystemFontOfSize:16.0f];
    self.textField.placeholder = @"标题(最多20字)";
    [self.containerView addSubview:self.textField];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.containerView addSubview:self.lineView];
    
    self.textView = [[SAMTextView alloc] init];
    self.textView.characterInteger = 200;
    self.textView.font = [UIFont systemFontOfSize:15.0f];
    self.textView.textColor = [UIColor colorWithHexString:@"333333"];
    self.textView.placeholder = @"内容(选填)";
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.textView.typingAttributes = dic;
    [self.containerView addSubview:self.textView];
    UILabel *totaLabel = [[UILabel alloc] init];
    totaLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
    totaLabel.font = [UIFont systemFontOfSize:15.0f];
    totaLabel.text = @"/200";
    totaLabel.textAlignment = NSTextAlignmentRight;
    [self.containerView addSubview:totaLabel];
    [totaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-20.0f);
    }];
    
    UILabel *inputLabel = [[UILabel alloc] init];
    inputLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
    inputLabel.font = [UIFont systemFontOfSize:15.0f];
    inputLabel.text = @"0";
    inputLabel.textAlignment = NSTextAlignmentRight;
    [self.containerView addSubview:inputLabel];
    [inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(totaLabel.mas_left);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-20.0f);
    }];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextViewTextDidChangeNotification object:nil] subscribeNext:^(NSNotification *notification) {
        STRONG_SELF
        if (notification.object == self.textView) {
            if (self.textView.text.length > 0) {
                inputLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
            }else {
                inputLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
            }
            inputLabel.text = [NSString stringWithFormat:@"%@",@(self.textView.text.length)];
        }
    }];
    self.templateView = [[TaskChooseContentView alloc] init];
    self.templateView.nameString = @"选择模板";
    self.templateView.chooseContentString = @"不使用模板";
    [self addSubview:self.templateView];
    
}
- (void)setupLayout {
    [self.courseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(5.0f);
        make.height.mas_offset(45.0f);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.courseView.mas_bottom).offset(5.0f);
        make.height.mas_offset(56.0f + 143.0f);
    }];
    
    [self.templateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.containerView.mas_bottom).offset(5.0f);
        make.height.mas_offset(45.0f);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f).priorityHigh();
        make.top.equalTo(self.containerView.mas_top).offset(20.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f).priorityHigh();
        make.top.equalTo(self.containerView.mas_top).offset(56.0f);
        make.height.mas_offset(1.0f);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f).priorityHigh();
        make.top.equalTo(self.lineView.mas_top).offset(10.0f);
        make.height.mas_offset(90.0f);
    }];
}
- (void)keyBoardHide {
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}
@end
