//
//  ResourceManagerViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceManagerViewController.h"
#import "ResourceManagerFetcher.h"
#import "ResourceListCell.h"
#import "FSDefaultHeaderFooterView.h"
#import "ResourceDetailViewController.h"
#import "ResourceUploadViewController.h"
#import "GetResourceDetailRequest.h"

@interface ResourceManagerViewController ()
@property (nonatomic, strong)GetResourceDetailRequest *detailRequest;
@end

@implementation ResourceManagerViewController

- (void)dealloc {
    DDLogDebug(@"release========>>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    ResourceManagerFetcher *fetcher = [[ResourceManagerFetcher alloc] init];
    fetcher.pagesize = 20;
    fetcher.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.navigationItem.title = @"资源管理";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)setupUI {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[FSDefaultHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FSDefaultHeaderFooterView"];
    [self.tableView registerClass:[ResourceListCell class] forCellReuseIdentifier:@"ResourceListCell"];
    [self setupNavRightView];
}
- (void)setupLayout {
    //15901259665
}
- (void)setupNavRightView {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame = CGRectMake(0, 0, 65, 30);
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navRightBtn setTitle:@"上传" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"上传资源icon正常态"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"上传资源icon点击态"] forState:UIControlStateHighlighted];
    [navRightBtn.titleLabel sizeToFit];
    navRightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30-5, 0, 30+5);
    navRightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, navRightBtn.titleLabel.width+5, 0, -navRightBtn.titleLabel.width-5);
    WEAK_SELF
    [[navRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [TalkingData trackEvent:@"发布资源"];
        ResourceUploadViewController *VC = [[ResourceUploadViewController alloc] init];
        FSNavigationController *nav = [[FSNavigationController alloc] initWithRootViewController:VC];
        VC.uploadSucceedBlock = ^() {
            STRONG_SELF
            self.emptyView.hidden = YES;
            self.errorView.hidden = YES;
            [self firstPageFetch];
        };
        [[self nyx_visibleViewController] presentViewController:nav animated:YES completion:^{
        }];
    }];
    [self nyx_setupRightWithCustomView:navRightBtn];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count > 0 ? 1 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResourceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResourceListCell" forIndexPath:indexPath];
    cell.element = self.dataArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDataScore
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FSDefaultHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FSDefaultHeaderFooterView"];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ResourceManagerRequestItem_Data_Resources_Elements *element = self.dataArray[indexPath.row];
    if (element.type.integerValue == 0) {
        [self requestResourceDetailWithResId:element.resId];
    }else {
        ResourceDetailViewController *vc = [[ResourceDetailViewController alloc] init];
        vc.urlString = element.url;
        vc.name = element.resName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)requestResourceDetailWithResId:(NSString *)resId {
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.detailRequest stopRequest];
    self.detailRequest = [[GetResourceDetailRequest alloc] init];
    self.detailRequest.resId = resId;
    [self.detailRequest startRequestWithRetClass:[GetResourceDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];;
            return;
        }
        GetResourceDetailRequestItem *item = (GetResourceDetailRequestItem *)retItem;
        ResourceDetailViewController *vc = [[ResourceDetailViewController alloc] init];
        vc.urlString = item.data.ai.previewUrl;
        vc.name = item.data.resName;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
