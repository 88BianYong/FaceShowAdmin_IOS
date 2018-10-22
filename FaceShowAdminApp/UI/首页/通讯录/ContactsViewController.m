//
//  ContactsViewController.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ContactsViewController.h"
#import "ClazsMemberListFetcher.h"
#import "ContactsListCell.h"
#import "AddMemberViewController.h"
#import "ContactsDetailViewController.h"
#import "HubeiContactsDetailViewController.h"
#import "HubeiAddMemberViewController.h"
#import "ContactsSearchHeadView.h"
#import "ContactsSearchResultView.h"
#import "MyInfoViewController.h"

@interface ContactsViewController ()<ContactsSearchHeadViewDelegate>
@property (nonatomic, strong) ContactsSearchHeadView *headerView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) ContactsSearchResultView *resultView;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    ClazsMemberListFetcher *fetcher = [[ClazsMemberListFetcher alloc] init];
    fetcher.pagesize = 10;
    fetcher.keyWords = @"";
    fetcher.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    self.title = @"人员管理";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)firstPageFetch {
    if (!self.dataFetcher) {
        return;
    }
    [self.dataFetcher stop];
    
    SAFE_CALL(self.requestDelegate, requestWillRefresh);
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        SAFE_CALL_OneParam(self.requestDelegate, requestEndRefreshWithError, error);
        [self.view nyx_stopLoading];
        [self stopAnimation];
        if (error) {
            if (isEmpty(self.dataArray)) {  // no cache 强提示, 加载失败界面
                self->_total = 0;
                [self showErroView];
            } else {
                [self.view nyx_showToast:error.localizedDescription];
            }
            [self checkHasMore];
            return;
        }
        
        // 隐藏失败界面
        [self hideErrorView];
        [self->_header setLastUpdateTime:[NSDate date]];
        self.total = total;
        [self.dataArray removeAllObjects];
        
        if (isEmpty(retItemArray.firstObject) && isEmpty(retItemArray.lastObject)) {
            self.emptyView.hidden = NO;
        } else {
            self.emptyView.hidden = YES;
            [self.dataArray addObjectsFromArray:retItemArray];
            [self checkHasMore];
            [self.dataFetcher saveToCache];
        }
        [self.tableView reloadData];
    }];
}

- (void)morePageFetch {
    [self.dataFetcher stop];
    SAFE_CALL(self.requestDelegate, requestWillFetchMore);
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        SAFE_CALL_OneParam(self.requestDelegate, requestEndFetchMoreWithError, error);
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self); if (!self) return;
            [self->_footer endRefreshing];
            if (error) {
                self.dataFetcher.pageindex--;
                [self.view nyx_showToast:error.localizedDescription];
                return;
            }
            
            NSMutableArray *students = [NSMutableArray arrayWithArray:self.dataArray.lastObject];
            [students addObjectsFromArray:retItemArray.lastObject];
            self.dataArray[1] = students;
            self.total = total;
            [self.tableView reloadData];
            [self checkHasMore];
        });
    }];
}

- (void)showErroView {
    self.errorView.hidden = NO;
    [self.view bringSubviewToFront:self.errorView];
}

- (void)hideErrorView {
    self.errorView.hidden = YES;
}

- (void)checkHasMore {
    [self setPullupViewHidden:[self.dataArray.lastObject count] >= _total];
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ContactsListCell class] forCellReuseIdentifier:@"ContactsListCell"];
    [self setupNavRightView];
    self.headerView = [[ContactsSearchHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.headerView.delegate = self;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(0);
        }
        make.height.mas_equalTo(44);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)setupNavRightView {
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"添加" action:^{
        STRONG_SELF
        [TalkingData trackEvent:@"添加学员"];
#ifdef HuBeiApp
        HubeiAddMemberViewController *vc = [[HubeiAddMemberViewController alloc] init];
        vc.saveSucceedBlock = ^{
            [self firstPageFetch];
        };
        [self.navigationController pushViewController:vc animated:YES];
#else
        AddMemberViewController *vc = [[AddMemberViewController alloc] init];
        vc.saveSucceedBlock = ^{
            [self firstPageFetch];
        };
        [self.navigationController pushViewController:vc animated:YES];
#endif
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 51;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [headerView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-1);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithHexString:@"999999"];
    label.text = section ? @"学员" : @"班主任";
    [whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsListCell" forIndexPath:indexPath];
    cell.data = self.dataArray[indexPath.section][indexPath.row];
    cell.isLastRow = indexPath.row == [self.dataArray[indexPath.section] count] - 1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GetUserInfoRequestItem_Data *data = self.dataArray[indexPath.section][indexPath.row];
        NSString *currentUserId = [UserManager sharedInstance].userModel.userID;
        if ([data.userId isEqualToString:currentUserId]) {
            MyInfoViewController *vc = [[MyInfoViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ContactsDetailViewController *vc = [[ContactsDetailViewController alloc] init];
            vc.userId = data.userId;
            vc.fromGroupTopicId = [UserManager sharedInstance].userModel.currentClass.topicId;
            vc.isAdministrator = indexPath.section == 0;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
#ifdef HuBeiApp
        HubeiContactsDetailViewController *vc = [[HubeiContactsDetailViewController alloc] init];
        GetUserInfoRequestItem_Data *data = self.dataArray[indexPath.section][indexPath.row];
        vc.userId = data.userId;
        vc.fromGroupTopicId = [UserManager sharedInstance].userModel.currentClass.topicId;
        vc.isAdministrator = indexPath.section == 0;
        [self.navigationController pushViewController:vc animated:YES];
#else
        ContactsDetailViewController *vc = [[ContactsDetailViewController alloc] init];
        GetUserInfoRequestItem_Data *data = self.dataArray[indexPath.section][indexPath.row];
        vc.userId = data.userId;
        vc.fromGroupTopicId = [UserManager sharedInstance].userModel.currentClass.topicId;
        vc.isAdministrator = indexPath.section == 0;
        [self.navigationController pushViewController:vc animated:YES];
#endif
    }
}

#pragma mark - SearchHeadViewDelegate
- (void)searchFieldDidBeginEditting {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (self.maskView.superview) {
        return;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue<11) {
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(44);
        }];
    }

    self.maskView = [[UIView alloc]init];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_top).mas_offset(44);
        make.left.right.bottom.mas_equalTo(0);
    }];

    self.resultView = [[ContactsSearchResultView alloc]init];
    WEAK_SELF
    [self.resultView setSelectBlock:^(NSIndexPath *indexPath, GetUserInfoRequestItem_Data *data) {
        STRONG_SELF
        [self.headerView endSearching];
        if (indexPath.section == 0) {
            NSString *currentUserId = [UserManager sharedInstance].userModel.userID;
            if ([data.userId isEqualToString:currentUserId]) {
                MyInfoViewController *vc = [[MyInfoViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                ContactsDetailViewController *vc = [[ContactsDetailViewController alloc] init];
                vc.userId = data.userId;
                vc.isAdministrator = indexPath.section == 0;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else {
#ifdef HuBeiApp
            HubeiContactsDetailViewController *vc = [[HubeiContactsDetailViewController alloc] init];
            vc.userId = data.userId;
            vc.isAdministrator = indexPath.section == 0;
            [self.navigationController pushViewController:vc animated:YES];
#else
            ContactsDetailViewController *vc = [[ContactsDetailViewController alloc] init];
            vc.userId = data.userId;
            vc.isAdministrator = indexPath.section == 0;
            [self.navigationController pushViewController:vc animated:YES];
#endif
        }
    }];
    [self.view addSubview:self.resultView];
    self.resultView.hidden = YES;
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.maskView.mas_top);
        make.left.right.bottom.mas_equalTo(0);
    }];
}
- (void)searchFieldDidEndEditting {
    if ([UIDevice currentDevice].systemVersion.floatValue<11) {
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
    }];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.maskView removeFromSuperview];
    [self.resultView removeFromSuperview];
    [self.emptyView removeFromSuperview];
}

- (void)searchFieldDidTextChange:(NSString *)searchStr{
    if (searchStr.length > 0){
        self.resultView.hidden = NO;
        self.emptyView.hidden = YES;
        [self.resultView searchWithString:searchStr];
    }else {
        self.resultView.hidden = YES;
        self.emptyView.hidden = YES;
    }
}

@end
