//
//  CreateDiscussViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateCommentViewController.h"
#import "SubordinateCourseViewController.h"
#import "UITextField+Restriction.h"
#import "TaskChooseContentView.h"
#import "CreateCommentRequest.h"
@interface CreateCommentViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) TaskChooseContentView *contentView;
@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, strong) CreateCommentRequest *commentRequest;
@property (nonatomic, strong) UIButton *publishButton;
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
    [self setupUI];
    [self setupLayout];
    [self setupNavigationRightView];
}
- (void)setupNavigationRightView{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [rightButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    WEAK_SELF
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self.view nyx_startLoading];
        [self requestForCreateComment];
    }];
    rightButton.enabled = NO;
    self.publishButton = rightButton;
    [self nyx_setupRightWithCustomView:rightButton];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        self.publishButton.enabled = [self.textField.text yx_stringByTrimmingCharacters].length != 0;
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(55.0f);
        make.height.mas_offset(56.0f);
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.characterInteger = 20;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.textColor = [UIColor colorWithHexString:@"333333"];
    self.textField.font = [UIFont boldSystemFontOfSize:16.0f];
    self.textField.placeholder = @"讨论标题(最多20字)";
    [self.view addSubview:self.textField];
    
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
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(5.0f);
        make.height.mas_offset(45.0f);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15.0f).priorityHigh();
        make.right.equalTo(self.view.mas_right).offset(-15.0f).priorityHigh();
        make.top.equalTo(self.contentView.mas_bottom).offset(25.0f);
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
    request.title = [self.textField.text yx_stringByTrimmingCharacters];
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
        }else {
            BLOCK_EXEC(self.reloadComleteBlock);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    self.commentRequest = request;
}
#pragma mark - UITextFieldDelegate

@end
