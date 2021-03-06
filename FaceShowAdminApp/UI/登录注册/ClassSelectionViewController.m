//
//  ClassSelectionViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ClassSelectionViewController.h"
#import "ClassListCell.h"
#import "ClassListRequest.h"
#import "EmptyView.h"
#import "AppDelegateHelper.h"
#import "AppUseRecordManager.h"

@interface ClassSelectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) ClassListRequestItem_clazsInfos *selectedClass;
@property (nonatomic, strong) ClassListRequest *getClassRequest;
@property (nonatomic, strong) ClassListRequestItem *requestItem;
@end

@implementation ClassSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
    [self requestClasses];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupNav
- (void)setupNav {
    self.title = @"选择班级";
    WEAK_SELF
    if (![UserManager sharedInstance].userModel.currentClass && [UserManager sharedInstance].mainPage == MainPage_ClassDetail) {
        [self nyx_setupLeftWithTitle:@"退出" action:^{
            STRONG_SELF
            [UserManager sharedInstance].loginStatus = NO;
        }];
    }
    
    self.navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navRightBtn.frame = CGRectMake(0, 0, 40, 30);
    self.navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navRightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.navRightBtn setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.navRightBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [self.navRightBtn addTarget:self action:@selector(navRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navRightBtn.enabled = NO;
    [self nyx_setupRightWithCustomView:self.navRightBtn];
}

- (void)navRightBtnAction:(UIButton *)sender {
    [UserManager sharedInstance].userModel.currentClass = self.selectedClass;
    [[UserManager sharedInstance] saveData];
    //使用情况统计
    AddAppUseRecordRequest *request = [[AddAppUseRecordRequest alloc]init];
    request.actionType = AppUseRecordActionType_GetStudentClazs;
    [[AppUseRecordManager sharedInstance]addRecord:request];
    [[NSNotificationCenter defaultCenter]postNotificationName:kClassDidSelectNotification object:nil];
}

#pragma mark - setupUI
- (void)setupUI {
        self.emptyView = [[EmptyView alloc]init];
        self.emptyView.title = @"暂未设置班级，请联系管理员";

        self.tableview = [[UITableView alloc]init];
        self.tableview.dataSource = self;
        self.tableview.delegate = self;
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableview.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
        self.tableview.allowsMultipleSelection = NO;
        [self.view addSubview:self.tableview];
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.tableview registerClass:[ClassListCell class] forCellReuseIdentifier:@"ClassListCell"];
}

#pragma mark - Request
- (void)requestClasses {
    [self.getClassRequest stopRequest];
    self.getClassRequest = [[ClassListRequest alloc]init];
    GetUserPlatformRequestItem_platformInfos *plat = [UserManager sharedInstance].userModel.platformRequestItem.data.platformInfos.firstObject;
    self.getClassRequest.platId = plat.platformId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.getClassRequest startRequestWithRetClass:[ClassListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.emptyView removeFromSuperview];
        
        ClassListRequestItem *item = (ClassListRequestItem *)retItem;
        if (isEmpty(item.data.clazsInfos)) {
            [self.view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return;
        }
        for (ClassListRequestItem_clazsInfos *info in item.data.clazsInfos) {
            if ([info.clazsId isEqualToString:[UserManager sharedInstance].userModel.currentClass.clazsId]) {
                self.selectedClass = info;
                self.navRightBtn.enabled = YES;
                break;
            }
        }
        self.requestItem = item;
        [UserManager sharedInstance].userModel.clazsInfos = item.data.clazsInfos;
        [[UserManager sharedInstance]saveData];
        [self.tableview reloadData];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requestItem.data.clazsInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassListCell"];
    ClassListRequestItem_clazsInfos *info = self.requestItem.data.clazsInfos[indexPath.row];
    cell.classInfo = info;
    if ([info.clazsId isEqualToString:self.selectedClass.clazsId]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedClass = self.requestItem.data.clazsInfos[indexPath.row];
    self.navRightBtn.enabled = YES;
}

- (void)refreshClasses {
    [self requestClasses];
    
}

@end
