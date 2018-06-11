//
//  PublishTaskHeaderView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PublishTaskHeaderView.h"

@implementation PublishTaskHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"334466"];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = @"新建任务";
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.top.equalTo(self.mas_top).offset(10.0f);
        }];
    }
    return self;
}
@end
