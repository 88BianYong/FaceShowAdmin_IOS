//
//  SubordinateCourseViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SubordinateCourseViewController.h"
#import "GetClassCourseRequest.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "SubordinateCourseCell.h"
#import "ErrorView.h"
@interface SubordinateCourseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) GetClassCourseRequest *courseRequest;
@property (nonatomic, strong) GetClassCourseRequestItem *itemData;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, assign) NSInteger chooseInteger;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) UIButton *publishButton;


@end

@implementation SubordinateCourseViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"所属课程";
    [self setupUI];
    [self setupLayout];
    [self requestForGetClassCourse];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - set
- (void)setItemData:(GetClassCourseRequestItem *)itemData {
    _itemData = itemData;
    self.publishButton.enabled = YES;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    if (self.courseId == nil) {
        self.chooseInteger = 0;
    }else {
        [self.itemData.data enumerateObjectsUsingBlock:^(GetClassCourseRequestItem_Data *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.courseId isEqualToString:self.courseId]) {
                self.chooseInteger = idx + 1;
                *stop = YES;
            }
        }];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chooseInteger inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES animated:YES];
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = 45.0f;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SubordinateCourseCell class] forCellReuseIdentifier:@"SubordinateCourseCell"];
    self.errorView = [[ErrorView alloc]init];
    self.errorView.hidden = YES;
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestForGetClassCourse];
    }];
    [self.view addSubview:self.errorView];
    [self setupNavigationRightView];
}
- (void)setupNavigationRightView{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [rightButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    WEAK_SELF
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.chooseInteger == 0) {
            BLOCK_EXEC(self.chooseSubordinateCoursBlock,nil,nil);
        }else {
            GetClassCourseRequestItem_Data *data = self.itemData.data[self.chooseInteger - 1];
            BLOCK_EXEC(self.chooseSubordinateCoursBlock,data.courseId,data.courseName);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    rightButton.enabled = NO;
    self.publishButton = rightButton;
    [self nyx_setupRightWithCustomView:rightButton];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDataScore
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemData.data.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubordinateCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubordinateCourseCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleString = [UserManager sharedInstance].userModel.currentClass.clazsName;
    }else {
        GetClassCourseRequestItem_Data *data = self.itemData.data[indexPath.row - 1];
        cell.titleString = data.courseName;
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.chooseInteger = indexPath.row;
}
#pragma mark - request
- (void)requestForGetClassCourse {
    [self.view nyx_startLoading];
    GetClassCourseRequest *request = [[GetClassCourseRequest alloc] init];
    request.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    WEAK_SELF
    [request startRequestWithRetClass:[GetClassCourseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.errorView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        self.itemData = retItem;
    }];
    self.courseRequest = request;
}
@end
