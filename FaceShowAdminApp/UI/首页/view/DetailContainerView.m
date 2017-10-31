//
//  DetailContainerView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "DetailContainerView.h"
static const NSUInteger kTagBase = 3333;
@interface DetailContainerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@end
@implementation DetailContainerView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupTabItems];
        [self setupUI];
    }
    return self;
}

- (void)setupTabItems{
    self.tabItemArray = @[@"项目详情",@"班级详情"];
}

- (void)setupUI{
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 34)];
    [self addSubview:self.topView];
    self.topView.backgroundColor = [UIColor whiteColor];
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.topView.frame.origin.y+self.topView.frame.size.height, self.frame.size.width, self.frame.size.height-self.topView.frame.size.height)];
    self.bottomScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.directionalLockEnabled = YES;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.delegate = self;
    [self addSubview:self.bottomScrollView];
    
    self.sliderView = [[UIView alloc]init];
    self.sliderView.backgroundColor = [UIColor colorWithHexString:@"0068bd"];
    self.sliderView.frame = CGRectMake(0, 0, 100, 2);
}
- (void)setContentViews:(NSArray<__kindof UIView *> *)contentViews{
    _contentViews = contentViews;
    for (UIView *v in self.topView.subviews) {
        [v removeFromSuperview];
    }
    for (UIView *v in self.bottomScrollView.subviews) {
        [v removeFromSuperview];
    }
    [self.sliderView removeFromSuperview];
    [_contentViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(self.bottomScrollView.frame.size.width*idx, 0, self.bottomScrollView.frame.size.width, self.bottomScrollView.frame.size.height);
        obj.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.bottomScrollView addSubview:obj];
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnWidth = self.topView.frame.size.width/_contentViews.count;
        b.frame = CGRectMake(btnWidth*idx, 0, btnWidth, self.topView.frame.size.height);
        [b setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateSelected];
        [b setTitle:self.tabItemArray[idx] forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        b.tag = kTagBase + idx;
        [self.topView addSubview:b];
        if (idx == 0) {
            b.selected = YES;
        }
    }];
    self.sliderView.center = CGPointMake(self.topView.frame.size.width/self.tabItemArray.count/2, self.topView.frame.size.height-1);
    [self addSubview:self.sliderView];
}

- (void)layoutSubviews{
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.frame.size.width*self.contentViews.count, self.bottomScrollView.frame.size.height);
}

- (void)btnAction:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    for (UIButton *b in self.topView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = NO;
        }
    }
    sender.selected = YES;
    NSInteger index = sender.tag - kTagBase;
    [UIView animateWithDuration:0.3 animations:^{
        self.sliderView.center = CGPointMake(self.topView.frame.size.width/self.tabItemArray.count/2*(1+index*2), self.sliderView.center.y);
    }];
    self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.frame.size.width*index, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat sliderX = offsetX/scrollView.contentSize.width*self.topView.frame.size.width;
    self.sliderView.center = CGPointMake(self.topView.frame.size.width/self.tabItemArray.count/2+sliderX, self.sliderView.center.y);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    for (UIButton *b in self.topView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = NO;
            if (b.tag-kTagBase == index) {
                b.selected = YES;
            }
        }
    }
}


@end
