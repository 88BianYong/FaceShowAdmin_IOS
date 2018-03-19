//
//  NSString+YXString.h
//  YXKit
//
//  Created by ChenJianjun on 15/5/12.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YXString)

@property (nonatomic, weak, readonly) NSDictionary *dictionary;

// 是否为有效字符串
- (BOOL)yx_isValidString;

// 安全字符串
- (NSString *)yx_safeString;

// 去除字符串两端的空格及换行
- (NSString *)yx_stringByTrimmingCharacters;

// 去掉两端空白，并合并中间多余空白
- (NSString *)nyx_stringByTrimmingExtraSpaces;

//两个时间比较 1为时间date较self大 0为相等 -1为时间date较self小
- (int)isAscendingCompareDate:(NSString *)date;

#pragma mark - encode & decode

// 字符串编码
- (NSString *)yx_encodeString;

// 字符串解码
- (NSString *)yx_decodeString;

@end

@interface NSString (YXTextChecking)

// 正则表达式判断
- (BOOL)yx_textCheckingWithPattern:(NSString *)pattern;

// 是否为手机号
- (BOOL)yx_isPhoneNum;

// 是否为http链接
- (BOOL)yx_isHttpLink;

// 加密
- (NSString *)yx_md5;

- (BOOL)nyx_isPureInt;

- (BOOL)includeChinese;

- (BOOL)includeEmoji;

@end

@interface NSString (YXTextFormatConvert)

// FullDateStringFormat: yyyy-MM-dd HH:mm:ss
- (NSString *)omitSecondOfFullDateString;

@end
