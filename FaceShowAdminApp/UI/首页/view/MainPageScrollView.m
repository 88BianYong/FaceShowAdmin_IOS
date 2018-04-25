//
//  MainPageScrollView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MainPageScrollView.h"

static const CGFloat kItemWidth = 50.f;
static const CGFloat kItemViewHeight = 93.f;
static const CGFloat kLeftMargin = 25.f;
static const CGFloat kTopMargin = 16.f;

@interface MainPageScrollView ()
@end
@implementation MainPageScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentSize = CGSizeMake(SCREEN_WIDTH , kItemViewHeight * 2);
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
                       @{@"name":@"资源管理",@"image":@"资源管理",@"tag":@(MainPagePushType_Resources)},
                       @{@"name":@"课程",@"image":@"课程",@"tag":@(MainPagePushType_Course)}];
    CGFloat spacingFloat = (SCREEN_WIDTH - kLeftMargin * 2 - (4 * kItemWidth))/3.0f;
    __block NSUInteger number = 4;
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = [obj[@"tag"] integerValue];
        [button setImage:[UIImage imageNamed:obj[@"image"]] forState:UIControlStateNormal];
        [self addSubview:button];
        NSUInteger row = idx / number;//行号
        NSUInteger loc = idx % number;//列号
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(25.f + (kItemWidth + spacingFloat) * loc);
            make.top.equalTo(self.mas_top).offset(kTopMargin + row * (kItemViewHeight + 1));
            make.size.mas_offset(CGSizeMake(kItemWidth, kItemWidth));
        }];
        WEAK_SELF
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG_SELF
            BLOCK_EXEC(self.actionBlock,[obj[@"tag"] integerValue]);
        }];
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
