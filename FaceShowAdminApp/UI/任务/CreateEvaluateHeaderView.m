//
//  CreateEvaluateHeaderView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateEvaluateHeaderView.h"

@implementation CreateEvaluateHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"提示标签"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_offset(CGSizeMake(17.0f, 17.0f));
        }];
        UILabel *totalLabel = [[UILabel alloc] init];
        totalLabel.font = [UIFont systemFontOfSize:14.0f];
        totalLabel.textColor = [UIColor colorWithHexString:@"999999"];
        totalLabel.text = @"点击标题可进行预览";
        [self addSubview:totalLabel];
        [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(10.0f);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}
@end
