//
//  ContactsSearchResultView.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/8/31.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ContactsSearchResultView.h"
#import "MJRefresh.h"
#import "ClazsMemberListFetcher.h"
#import "PlaceSearchEmptyView.h"
#import "ErrorView.h"
@interface ContactsSearchResultView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSArray<GetUserInfoRequestItem_Data *> *> * results;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) MJRefreshFooterView *footer;
@property (nonatomic, strong) ClazsMemberListFetcher *dataFetcher;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, assign) long total;
@property (nonatomic, strong) PlaceSearchEmptyView *emptyView;
@property (nonatomic, strong) ErrorView *errorView;
@end

@implementation ContactsSearchResultView

- (void)dealloc {
    [_footer free];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.searchText = @"";
    self.results = [NSMutableArray array];
    ClazsMemberListFetcher *fetcher = [[ClazsMemberListFetcher alloc] init];
    fetcher.pagesize = 10;
    fetcher.keyWords = self.searchText;
    self.dataFetcher = fetcher;

    self.tableView = [[UITableView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 55;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[ContactsListCell class] forCellReuseIdentifier:@"ContactsListCell"];

    WEAK_SELF
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.tableView;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self morePageFetch];
    };
    _footer.alpha = 0;

    self.emptyView = [[PlaceSearchEmptyView alloc]init];
    [self addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;

    if (!self.errorView) {
        self.errorView = [[ErrorView alloc]init];
    }

    [self.errorView setRetryBlock:^{
        STRONG_SELF
        if (!self) return;
        [self nyx_startLoading];
        [self firstPageFetch];
    }];
    [self addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    [self hideErrorView];

}

- (void)searchWithString:(NSString *)searchText{
    self.searchText = searchText;
    [self firstPageFetch];
}

- (void)firstPageFetch {
    if (!self.dataFetcher) {
        return;
    }
    [self.dataFetcher stop];
    ClazsMemberListFetcher *fetcher = [[ClazsMemberListFetcher alloc] init];
    fetcher.pagesize = 10;
    fetcher.keyWords = self.searchText;
    fetcher.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    self.dataFetcher = fetcher;
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        [self nyx_stopLoading];
        if (error) {
            if (isEmpty(self.results)) {  // no cache 强提示, 加载失败界面
                self->_total = 0;
                [self showErroView];
            } else {
                [self nyx_showToast:error.localizedDescription];
            }
            [self checkHasMore];
            return;
        }

        // 隐藏失败界面
        [self hideErrorView];
        self.total = total;
        [self.results removeAllObjects];
        if (isEmpty(retItemArray.firstObject) && isEmpty(retItemArray.lastObject)) {
            self.emptyView.hidden = NO;
        } else {
            self.emptyView.hidden = YES;
            [self.results addObjectsFromArray:retItemArray];
            [self checkHasMore];
            [self.dataFetcher saveToCache];
        }
        [self.tableView reloadData];
    }];
}

- (void)morePageFetch {
    [self.dataFetcher stop];
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self); if (!self) return;
            [self->_footer endRefreshing];
            if (error) {
                self.dataFetcher.pageindex--;
                [self nyx_showToast:error.localizedDescription];
                return;
            }

            NSMutableArray *students = [NSMutableArray arrayWithArray:self.results.lastObject];
            [students addObjectsFromArray:retItemArray.lastObject];
            self.results[1] = students;
            self.total = total;
            [self.tableView reloadData];
            [self checkHasMore];
        });
    }];
}



- (void)showErroView {
    self.errorView.hidden = NO;
    [self bringSubviewToFront:self.errorView];
}

- (void)hideErrorView {
    self.errorView.hidden = YES;
}

- (void)checkHasMore {
    [self setPullupViewHidden:[self.results.lastObject count] >= _total];
}

- (void)setPullupViewHidden:(BOOL)hidden
{
    _footer.alpha = hidden ? 0:1;
}

- (void)updateWithBottomHeight:(CGFloat)height {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.results.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.results[section] count];
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
    cell.data = self.results[indexPath.section][indexPath.row];
    cell.isLastRow = indexPath.row == [self.results[indexPath.section] count] - 1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BLOCK_EXEC(self.selectBlock,indexPath,self.results[indexPath.section][indexPath.row]);
}

@end
