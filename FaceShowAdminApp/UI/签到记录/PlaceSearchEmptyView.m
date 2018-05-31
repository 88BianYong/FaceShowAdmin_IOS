//
//  PlaceSearchEmptyView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/5/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PlaceSearchEmptyView.h"

@implementation PlaceSearchEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    UILabel *emptyLabel = [[UILabel alloc]init];
    emptyLabel.text = @"无结果";
    emptyLabel.font = [UIFont boldSystemFontOfSize:18];
    emptyLabel.textColor = [UIColor colorWithHexString:@"333333"];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:emptyLabel];
    [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.centerX.mas_equalTo(0);
    }];
}

@end
