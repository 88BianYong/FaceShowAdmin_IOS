//
//  SignInPlaceSearchResultView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/5/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignInPlaceSearchResultView.h"
#import "MJRefresh.h"

@interface SignInPlaceSearchResultView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<BMKPoiInfo *> * results;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) MJRefreshFooterView *footer;
@end

@implementation SignInPlaceSearchResultView

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
    self.tableView = [[UITableView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 55;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[PlaceSearchResultCell class] forCellReuseIdentifier:@"PlaceSearchResultCell"];
    
    WEAK_SELF
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.tableView;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        BLOCK_EXEC(self.searchMoreBlock);
    };
    _footer.alpha = 0;
}

- (void)updateWithResults:(NSArray<BMKPoiInfo *> *)results withKey:(NSString *)key{
    self.results = [NSMutableArray arrayWithArray:results];
    self.key = key;
    [self.tableView reloadData];
    self.footer.alpha = results.count==20? 1:0;
}

- (void)updateWithBottomHeight:(CGFloat)height {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
}

- (void)updateWithNextPageResults:(NSArray<BMKPoiInfo *> *)results {
    [self.footer endRefreshing];
    [self.results addObjectsFromArray:results];
    [self.tableView reloadData];
    self.footer.alpha = results.count==20? 1:0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceSearchResultCell"];
    cell.poiInfo = self.results[indexPath.row];
    cell.isCurrent = NO;
    cell.keyword = self.key;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BLOCK_EXEC(self.selectBlock,self.results[indexPath.row]);
}

@end
