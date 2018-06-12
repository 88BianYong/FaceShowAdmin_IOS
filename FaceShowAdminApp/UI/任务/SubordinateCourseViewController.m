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
@interface SubordinateCourseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) GetClassCourseRequest *courseRequest;
@property (nonatomic, strong) GetClassCourseRequestItem *itemData;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@end

@implementation SubordinateCourseViewController

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
    [self.tableView reloadData];
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = 44.0f;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SubordinateCourseCell class] forCellReuseIdentifier:@"SubordinateCourseCell"];
    
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        self.itemData = retItem;
    }];
    self.courseRequest = request;
}
@end
