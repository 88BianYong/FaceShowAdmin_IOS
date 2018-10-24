//
//  AboutFaceShowViewController.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AboutFaceShowViewController.h"

@interface AboutFaceShowViewController ()
@property (nonatomic, strong) MASViewAttribute *lastArribute;
@end

@implementation AboutFaceShowViewController

- (void)dealloc{
    NSLog(@"%@ -- dealloc",NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于App";

    UIButton *update = [UIButton buttonWithType:UIButtonTypeCustom];
    [update setBackgroundColor:[UIColor randomColor]];
    [update setTitle:@"版本更新" forState:UIControlStateNormal];
    [self.view addSubview:update];
    [update mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 35));
        make.top.mas_equalTo(100);
    }];

    self.lastArribute = update.mas_bottom;

    NSArray<NSString *> *arr = @[@"FaceShowAdmin",@"FaceShowAdmin_Hubei",@"FaceShow",@"FaceShow_Hubei"];
    NSArray<NSString *> *appId = @[@"1287432795",@"1400673895",@"1287430670",@"1400673669"];

    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *appBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [appBtn setTitle:obj forState:UIControlStateNormal];
        [appBtn setBackgroundColor:[UIColor randomColor]];
        [self.view addSubview:appBtn];
        [appBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(self.lastArribute).offset(1);
        }];
        self.lastArribute = appBtn.mas_bottom;
        [[appBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",appId[idx]];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
        }];
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
