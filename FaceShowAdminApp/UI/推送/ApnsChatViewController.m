//
//  ApnsChatViewController.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/9/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ApnsChatViewController.h"

@interface ApnsChatViewController ()

@end

@implementation ApnsChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAK_SELF
    [self nyx_setupLeftWithImageName:@"返回页面按钮正常态" highlightImageName:@"返回页面按钮点击态" action:^{
        STRONG_SELF
        [self backAction];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction {
    [super backAction];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
