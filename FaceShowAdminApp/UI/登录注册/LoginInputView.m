//
//  LoginInputView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "LoginInputView.h"

@implementation LoginInputField
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    return CGRectInset(bounds, 0, 15);
//}
//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    return CGRectInset(bounds, 0, 15);
//}
//- (CGRect)placeholderRectForBounds:(CGRect)bounds {
//    return CGRectInset(bounds, 0, 15);
//}
@end

@interface LoginInputView ()<UITextFieldDelegate>
@end

@implementation LoginInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    self.textField = [[LoginInputField alloc]init];
    self.textField.font = [UIFont boldSystemFontOfSize:14];
    self.textField.textColor = [UIColor colorWithHexString:@"333333"];
    self.textField.tintColor = [UIColor colorWithHexString:@"333333"];
    self.textField.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.clipsToBounds = YES;
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(12);
    }];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.textField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"B5B4B9"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

@end
