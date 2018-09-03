//
//  MemberHomeworkDetailViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MemberHomeworkDetailViewController.h"
#import "HomeworkMemberView.h"
#import "PreviewPhotosView.h"
#import "HomeworkCommentView.h"
#import "GetUserHomeworksRequest.h"
#import "ReviewUserHomeworkRequest.h"
#import "GetUserHomeworkDetailRequest.h"
#import "ErrorView.h"
#import "QASlideView.h"
#import "HomeworkDetailView.h"
#import "YXResourceDisplayViewController.h"
#import "YXPlayerViewController.h"
#import "ResourceTypeMapping.h"

@interface MemberHomeworkDetailViewController ()<QASlideViewDelegate,QASlideViewDataSource,YXBrowserExitDelegate>
@property (nonatomic, strong) QASlideView *slideView;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, assign) BOOL isPlayerShowing;
@end

@implementation MemberHomeworkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupCancleButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.slideView = [[QASlideView alloc] init];
    self.slideView.dataSource = self;
    self.slideView.delegate = self;
    self.slideView.currentIndex = self.currentIndex;
    [self.view addSubview:self.slideView];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setupCancleButton {
    self.cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, 30)];
    self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.cancleButton setTitle:@"取消评分" forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [self nyx_setupRightWithCustomView:self.cancleButton];
}

- (void)cancleAction {
    HomeworkDetailView *view = [self.slideView itemViewAtIndex:self.currentIndex];
    [view reviewUserHomeworkWithComment:@""];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    self.slideView.currentIndex = currentIndex;
}

#pragma mark - QASlideViewDataSource
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return self.dataArray.count;
}
- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    HomeworkDetailView *infoView = [[HomeworkDetailView alloc]init];
    infoView.data = self.dataArray[index];
    infoView.stepId = self.stepId;
    WEAK_SELF
    [infoView setCommentComleteBlock:^(NSString *comment) {
        STRONG_SELF
        [self reloadCancleButtonWithComent:comment];
        BLOCK_EXEC(self.commentComleteBlock,comment);
    }];
    [infoView setPreviewAction:^(GetHomeworkRequestItem_attachmentInfo *attachment) {
        STRONG_SELF
        [self previewAttachment:attachment];
    }];
    return infoView;
}

#pragma mark - QASlideViewDelegate
- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    if (self.isPlayerShowing) {
        return;
    }
    self.currentIndex = to;
    HomeworkDetailView *view = [self.slideView itemViewAtIndex:self.currentIndex];
    [self reloadCancleButtonWithComent:view.data.assess];
}

- (void)reloadCancleButtonWithComent:(NSString *)comment {
    if ([comment length] <= 0) {
        self.cancleButton.hidden = YES;
    }else {
        self.cancleButton.hidden = NO;
    }
}

#pragma mark - previewAttachment
- (void)previewAttachment:(GetHomeworkRequestItem_attachmentInfo *)attach {
    if ([[ResourceTypeMapping resourceTypeWithString:attach.ext] isEqualToString:@"video"]) {
        self.currentIndex = self.slideView.currentIndex;
        self.isPlayerShowing = YES;
        YXPlayerViewController *vc = [[YXPlayerViewController alloc] init];
        vc.videoUrl = attach.previewUrl;
        vc.title = attach.resName;
        vc.exitDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        YXResourceDisplayViewController *vc = [[YXResourceDisplayViewController alloc]init];
        vc.urlString = attach.previewUrl;
        vc.name = attach.resName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - YXBrowserExitDelegate
- (void)browserExit {
    self.isPlayerShowing = NO;
    self.slideView.currentIndex = self.currentIndex;
    [self.slideView reloadData];
}
@end
