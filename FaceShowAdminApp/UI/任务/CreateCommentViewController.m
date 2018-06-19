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
#import "TaskChooseContentView.h"
#import "CreateCommentRequest.h"
@interface CreateCommentViewController ()
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, strong) TaskChooseContentView *contentView;
@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, strong) CreateCommentRequest *commentRequest;
@end

@implementation CreateCommentViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release=====>>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.navigationItem.title = @"新建讨论";
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"提交" action:^{
        STRONG_SELF
        [self.view nyx_startLoading];
        [self requestForCreateComment];
    }];
    [self setupUI];
    [self setupLayout];
}
#pragma mark - setupUI
- (void)setupUI {
    self.textView = [[SAMTextView alloc] init];
    self.textView.characterInteger = 20;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.bounces = NO; 
    self.textView.textColor = [UIColor colorWithHexString:@"333333"];
    self.textView.font = [UIFont boldSystemFontOfSize:16.0f];
    self.textView.placeholder = @"讨论标题(最多20字)";
    self.textView.textContainerInset = UIEdgeInsetsMake(20.0f, 15.0f, 18.0, 15.0f);
    [self.view addSubview:self.textView];
    
    self.contentView = [[TaskChooseContentView alloc] init];
    self.contentView.chooseContentString = [UserManager sharedInstance].userModel.currentClass.clazsName;
    [self.view addSubview:self.contentView];
    WEAK_SELF
    self.contentView.pushSubordinateCourseBlock = ^{
        STRONG_SELF
        SubordinateCourseViewController *VC = [[SubordinateCourseViewController alloc] init];
        VC.courseId = self.courseId;
        VC.chooseSubordinateCoursBlock = ^(NSString *courseId,NSString *courseName) {
            if (courseId == nil) {
                self.contentView.chooseType = SubordinateCourse_Class;
                self.contentView.chooseContentString = [UserManager sharedInstance].userModel.currentClass.clazsName;
                self.courseId = nil;
            }else {
                self.contentView.chooseType = SubordinateCourse_Course;
                self.courseId = courseId;
                self.contentView.chooseContentString = courseName;
            }
        };
        [self.navigationController pushViewController:VC animated:YES];
    };
}
- (void)setupLayout {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(5.0f);
        make.height.mas_offset(56.0f);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.textView.mas_bottom).offset(5.0f);
        make.height.mas_offset(45.0f);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - request
- (void)requestForCreateComment {
    CreateCommentRequest *request = [[CreateCommentRequest alloc] init];
    if (self.contentView.chooseType == SubordinateCourse_Course) {
        request.courseId = self.courseId;
    }else {
        request.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    }
    request.title = self.textView.text;
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    self.commentRequest = request;
}
#pragma mark - UITextFieldDelegate

@end
