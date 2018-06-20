//
//  UITextField+Restriction.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "UITextField+Restriction.h"
#import <objc/runtime.h>

@implementation UITextField (Restriction)
static const char characterIntegerKey = '\0';
- (void)setCharacterInteger:(NSInteger)characterInteger {
    [self willChangeValueForKey:@"characterInteger"];
    objc_setAssociatedObject(self, &characterIntegerKey,
                             @(characterInteger), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"characterInteger"];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        if (x.object == self) {
            [self textFieldChanged:x.object];
        }
    }];
}
- (NSInteger)characterInteger {
    return [objc_getAssociatedObject(self, &characterIntegerKey) integerValue];
}
#pragma mark - Method
- (void)textFieldChanged:(UITextField *)textField {
    NSString *toBeString = textField.text;
    textField.text = [self disable_emoji:toBeString];
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
    if([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString];
            if(getStr && getStr.length > 0) {
                textField.text = getStr;
            }
        }
    } else{
        NSString *getStr = [self getSubString:toBeString];
        if(getStr && getStr.length > 0) {
            textField.text= getStr;
        }
    }
}
- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

-(NSString *)getSubString:(NSString*)string {
    if (string.length > self.characterInteger) {
        return [string substringToIndex:self.characterInteger];
    }
    return nil;
}
@end
