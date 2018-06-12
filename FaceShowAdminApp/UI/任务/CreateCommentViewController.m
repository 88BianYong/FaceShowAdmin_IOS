//
//  CreateDiscussViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateCommentViewController.h"
#import "SubordinateCourseViewController.h"
@interface CreateCommentViewController ()

@end

@implementation CreateCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新建讨论";
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"所属课程" action:^{
        STRONG_SELF
        SubordinateCourseViewController *VC = [[SubordinateCourseViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
