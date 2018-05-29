//
//  SignInPlaceSearchResultView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/5/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignInPlaceSearchResultView.h"

@interface SignInPlaceSearchResultView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<BMKPoiInfo *> * results;
@end

@implementation SignInPlaceSearchResultView

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
}

- (void)updateWithResults:(NSArray<BMKPoiInfo *> *)results {
    self.results = results;
    [self.tableView reloadData];
}

- (void)updateWithBottomHeight:(CGFloat)height {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceSearchResultCell"];
    cell.poiInfo = self.results[indexPath.row];
    cell.isCurrent = NO;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BLOCK_EXEC(self.selectBlock,self.results[indexPath.row]);
}

@end
