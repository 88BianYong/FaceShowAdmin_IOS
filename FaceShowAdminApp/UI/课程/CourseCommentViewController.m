//
//  CourseCommentViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCommentViewController.h"
#import "CourseCommentCell.h"
#import "CourseCommentTitleView.h"
#import "CourseCommentHeaderView.h"
#import "CommentInputView.h"
#import "CourseCommentDataFetcher.h"
#import "LikeCommentRequest.h"
#import "ClassMomentFloatingView.h"
#import "DeleteCommentRequest.h"

@interface CourseCommentViewController ()
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) LikeCommentRequest *likeRequest;
@property (nonatomic, strong) DeleteCommentRequest *deleteRequest;
@property (nonatomic, strong) NSString *currentTime;
@property (nonatomic, strong) GetCourseCommentRequestItem *commentRequestItem;
@property (nonatomic, strong) ClassMomentFloatingView *floatingView;
@end

@implementation CourseCommentViewController

- (instancetype)initWithStepId:(NSString *)stepId {
    if (self = [super init]) {
        self.stepId = stepId;
    }
    return self;
}

- (void)viewDidLoad {
    self.bIsGroupedTableViewStyle = YES;
    CourseCommentDataFetcher *fetcher = [[CourseCommentDataFetcher alloc]init];
    fetcher.stepId = self.stepId;
    fetcher.lastID = 0;
    WEAK_SELF
    [fetcher setFinishBlock:^(GetCourseCommentRequestItem *item){
        STRONG_SELF
        self.commentRequestItem = item;
        if (!self.tableView.tableHeaderView) {
            NSString *title = item.data.title;
            CGFloat height = [CourseCommentTitleView heightForTitle:title];
            CourseCommentTitleView *headerView = [[CourseCommentTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, height)];
            headerView.title = title;
            self.tableView.tableHeaderView = headerView;
        }
        if (item.data.elements.count > 0) {
            return;
        }
        if (self.dataArray.count == 0) {
            [self.view nyx_showToast:@"暂无评论"];
        }else {
            [self.view performSelector:@selector(nyx_showToast:) withObject:@"暂无更多" afterDelay:1];
        }
    }];
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"课程讨论";
    [self.emptyView removeFromSuperview];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.floatingView = [[ClassMomentFloatingView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CourseCommentCell class] forCellReuseIdentifier:@"CourseCommentCell"];
    [self.tableView registerClass:[CourseCommentHeaderView class] forHeaderFooterViewReuseIdentifier:@"CourseCommentHeaderView"];
}

- (void)favorCommentWithIndex:(NSInteger)index {
    GetCourseCommentRequestItem_element *element = self.dataArray[index];
    [self.likeRequest stopRequest];
    self.likeRequest = [[LikeCommentRequest alloc]init];
    self.likeRequest.commentRecordId = element.elementId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.likeRequest startRequestWithRetClass:[LikeCommentRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view nyx_showToast:@"提交成功"];
        LikeCommentRequestItem *item = (LikeCommentRequestItem *)retItem;
        element.likeNum = item.data.userNum;
        element.userLiked = @"1";
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)deleteCommentWithIndex:(NSInteger)index {
    [TalkingData trackEvent:@"删除讨论"];
    GetCourseCommentRequestItem_element *element = self.dataArray[index];
    [self.deleteRequest stopRequest];
    self.deleteRequest = [[DeleteCommentRequest alloc]init];
    self.deleteRequest.commentRecordId = element.elementId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.deleteRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.view nyx_showToast:@"删除成功"];
        [self.dataArray removeObjectAtIndex:index];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCommentCell"];
    cell.bottomLineHidden = indexPath.row==self.dataArray.count-1;
    cell.currentTime = self.commentRequestItem.currentTime;
    cell.item = self.dataArray[indexPath.row];
    WEAK_SELF
    [cell setMenuBlock:^(UIButton *sender){
        STRONG_SELF
        CGRect rect = [sender convertRect:sender.bounds toView:self.view];
        [self showFloatView:rect withRow:indexPath.row];
    }];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CourseCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CourseCommentHeaderView"];
    header.countStr = self.commentRequestItem.data.totalElements;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - 弹出菜单
- (void)showFloatView:(CGRect)rect withRow:(NSInteger)row{
    if (self.floatingView.superview != nil) {
        [self.floatingView hiddenViewAnimate:YES];
        return;
    }
    WEAK_SELF
    self.floatingView.classMomentFloatingBlock = ^(ClassMomentClickStatus status) {
        STRONG_SELF
        if (status == ClassMomentClickStatus_Like){
            [self favorCommentWithIndex:row];
        }else {
            [self deleteCommentWithIndex:row];
        }
    };
    [self.view addSubview:self.floatingView];
    [self.floatingView reloadFloatingView:rect withStyle:ClassMomentFloatingStyle_Like | ClassMomentFloatingStyle_Delete];    
}
@end
