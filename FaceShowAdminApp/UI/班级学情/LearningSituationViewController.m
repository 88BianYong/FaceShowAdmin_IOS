//
//  LearningSituationViewController.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/15.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "LearningSituationViewController.h"
#import "ScoreDefineViewController.h"

@interface LearningSituationViewController ()
@property (nonatomic, strong) NSString *clazsId;
@end

@implementation LearningSituationViewController

- (instancetype)initWithClazsId:(NSString *)clazsId {
    if (self = [super init]) {
        self.clazsId = clazsId;
        [self setupUI];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班级学情";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupUI {
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"积分设置" action:^{
        STRONG_SELF
        ScoreDefineViewController *vc = [[ScoreDefineViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
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
