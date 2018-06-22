//
//  SAMTextView+Restriction.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SAMTextView+Restriction.h"
#import <objc/runtime.h>
@implementation SAMTextView (Restriction)
static const char characterIntegerKey = '\0';
- (void)setCharacterInteger:(NSInteger)characterInteger {
    [self willChangeValueForKey:@"characterInteger"];
    objc_setAssociatedObject(self, &characterIntegerKey,
                             @(characterInteger), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"characterInteger"];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextViewTextDidChangeNotification object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        if (x.object == self) {
            [self textViewChanged:x.object];
        }
    }];
}
- (NSInteger)characterInteger {
    return [objc_getAssociatedObject(self, &characterIntegerKey) integerValue];
}
static NSString *oldStringKey = @"oldStringKey";
- (void)setOldString:(NSString *)oldString {
    objc_setAssociatedObject(self, &oldStringKey, oldString, OBJC_ASSOCIATION_COPY);
}
- (NSString *)oldString {
    return objc_getAssociatedObject(self, &oldStringKey);
}

#pragma mark - Method
- (void)textViewChanged:(SAMTextView *)textView {
    NSString *toBeString = textView.text;
    textView.text = [self disable_emoji:toBeString];
    NSString *lang = [[textView textInputMode] primaryLanguage];
    if([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if(!position) {
            NSString *getStr = [self getSubString:toBeString];
            if(getStr && getStr.length > 0) {
                textView.text = getStr;
            }
        }
    } else{
        NSString *getStr = [self getSubString:toBeString];
        if(getStr && getStr.length > 0) {
            textView.text= getStr;
        }
    }
    if (self.oldString.length != textView.text.length) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"keyUploadHeight" object:textView];
    }
    self.oldString = textView.text;
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
