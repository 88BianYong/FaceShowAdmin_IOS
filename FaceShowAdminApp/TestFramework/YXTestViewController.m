//
//  YXTestViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTestViewController.h"
#import "SignInPlaceViewController.h"
#import "TrainingProfileViewController.h"
#import "MyTrainingProjectViewController.h"
#import "TrainingProjectDetailViewController.h"
#import "ProjectFilterViewController.h"
#import "HomeworkDetailViewController.h"
#import "YXApnsContentModel.h"
#import "MultipleCreateViewController.h"
#import "CreateSignInViewController.h"
#import "SignInListViewController.h"
@interface YXTestViewController ()
@end

@implementation YXTestViewController
- (void)viewDidLoad {
    self.devTestActions = @[@"testSigninPlace",@"testTrainingProfile",@"testMyProject",@"testProjectDetail",@"testFilter",@"testHomeworkDetail",@"testMultipleCreateViewController",@"testCreateSignInViewController",@"testSignInListViewController"];
    [super viewDidLoad];
}

- (void)testSigninPlace {
    SignInPlaceViewController *vc = [[SignInPlaceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testTrainingProfile {
    TrainingProfileViewController *vc = [[TrainingProfileViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)testMyProject {
    MyTrainingProjectViewController *vc = [[MyTrainingProjectViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)testProjectDetail {
    TrainingProjectDetailViewController *vc = [[TrainingProjectDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)testFilter {
    ProjectFilterViewController *vc = [[ProjectFilterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)testHomeworkDetail {
    HomeworkDetailViewController *vc = [[HomeworkDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)testMultipleCreateViewController{
    MultipleCreateViewController *vc = [[MultipleCreateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)testCreateSignInViewController{
    CreateSignInViewController *vc = [[CreateSignInViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)testSignInListViewController{
    SignInListViewController *list = [[SignInListViewController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
}
@end

