//
//  YXTestViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTestViewController.h"
#import "SignInPlaceViewController.h"

@interface YXTestViewController ()
@end

@implementation YXTestViewController
- (void)viewDidLoad {
    self.devTestActions = @[@"testSigninPlace"];
    [super viewDidLoad];
}

- (void)testSigninPlace {
    SignInPlaceViewController *vc = [[SignInPlaceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

