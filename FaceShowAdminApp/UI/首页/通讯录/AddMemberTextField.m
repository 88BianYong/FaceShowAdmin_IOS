//
//  AddMemberTextField.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "AddMemberTextField.h"

@interface AddMemberTextField ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation AddMemberTextField

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.font = [UIFont systemFontOfSize:14];
    self.textColor = [UIColor colorWithHexString:@"333333"];
    UIView *holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, self.height)];
    holderView.backgroundColor = [UIColor clearColor];
    self.leftView = holderView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightView = holderView;
    self.rightViewMode = UITextFieldViewModeAlways;
    self.delegate = self;
    
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setNeedBottomLine:(BOOL)needBottomLine {
    _needBottomLine = needBottomLine;
    self.bottomLineView.hidden = !needBottomLine;
}

@end
