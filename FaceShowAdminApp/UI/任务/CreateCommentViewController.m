//
//  CreateDiscussViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateCommentViewController.h"
#import "SubordinateCourseViewController.h"
#import "SAMTextView+Restriction.h"
@interface CreateCommentViewController ()
@property (nonatomic, strong) SAMTextView *textView;
@end

@implementation CreateCommentViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release=====>>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新建讨论";
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"所属课程" action:^{
        STRONG_SELF
        SubordinateCourseViewController *VC = [[SubordinateCourseViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    self.textView = [[SAMTextView alloc] init];
    self.textView.characterInteger = 10;
    self.textView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_offset(50.0f);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextFieldDelegate

@end
