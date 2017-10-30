//
//  MainPageScrollView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MainPageScrollView.h"
@interface MainPageScrollView ()
@end
@implementation MainPageScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentSize = CGSizeMake(SCREEN_WIDTH + 65.0f, 100.0f);
        self.showsHorizontalScrollIndicator = NO;
        [self setupUI];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    NSArray *array = @[@{@"name":@"通讯录",@"image":@"通讯录",@"tag":@(MainPagePushType_Contacts)},
                       @{@"name":@"通知管理",@"image":@"通知管理",@"tag":@(MainPagePushType_Notice)},
                       @{@"name":@"签到记录",@"image":@"签到记录",@"tag":@(MainPagePushType_Check)},
                       @{@"name":@"日程管理",@"image":@"日程管理",@"tag":@(MainPagePushType_Schedule)},
                       @{@"name":@"资源管理",@"image":@"资源管理",@"tag":@(MainPagePushType_Resources)}];
    CGFloat spacingFloat = (SCREEN_WIDTH - 10.0f - 25.0f - (4 * 50.0f))/4.0f;
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = [obj[@"tag"] integerValue] + 1;
        [button setImage:[UIImage imageNamed:obj[@"image"]] forState:UIControlStateNormal];
        [self addSubview:button];
        if (idx == 0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(25.0f);
                make.top.equalTo(self.mas_top).offset(15.0f);
                make.size.mas_offset(CGSizeMake(50.0f, 50.0f));
            }];
        }else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(25.0f + (50.0f + spacingFloat) * idx);
                make.top.equalTo(self.mas_top).offset(15.0f);
                make.size.mas_offset(CGSizeMake(50.0f, 50.0f));
            }];
        }
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"666666"];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = obj[@"name"];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).mas_offset(9.0f);
            make.centerX.equalTo(button.mas_centerX);
        }];
    }];
}

@end
