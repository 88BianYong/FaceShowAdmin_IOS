//
//  SignInPlaceViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/5/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignInPlaceViewController.h"
#import "SignInPlaceHeaderView.h"
#import "SignInPlaceSearchResultView.h"
#import "PlaceSearchEmptyView.h"

@interface SignInPlaceViewController ()<UITableViewDelegate,UITableViewDataSource,SignInPlaceHeaderViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SignInPlaceHeaderView *headerView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) SignInPlaceSearchResultView *resultView;
@property (nonatomic, strong) PlaceSearchEmptyView *emptyView;
@property (nonatomic, strong) NSArray<BMKPoiInfo *> * results;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation SignInPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"指定签到地点";
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"确定" action:^{
        STRONG_SELF
        if (self.results.count == 0) {
            [self.view nyx_showToast:@"请先指定签到地点"];
            return;
        }
        BLOCK_EXEC(self.selectBlock,self.results[self.currentIndex]);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.headerView = [[SignInPlaceHeaderView alloc]init];
    self.headerView.nearbyPoi = self.nearbyPoi;
    self.headerView.delegate = self;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(0);
        }
        make.height.mas_equalTo(44+200*kPhoneWidthRatio);
    }];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    [self.tableView registerClass:[PlaceSearchResultCell class] forCellReuseIdentifier:@"PlaceSearchResultCell"];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        [self.resultView updateWithBottomHeight:SCREEN_HEIGHT-keyboardFrame.origin.y];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.headerView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.headerView viewWillDisappear];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceSearchResultCell"];
    cell.poiInfo = self.results[indexPath.row];
    cell.isCurrent = indexPath.row == self.currentIndex;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.row;
    [self.tableView reloadData];
    [self.headerView moveToPoi:self.results[indexPath.row]];
}
#pragma mark - SignInPlaceHeaderViewDelegate
- (void)searchFieldDidBeginEditting {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (self.maskView.superview) {
        return;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue<11) {
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(44+200*kPhoneWidthRatio);
        }];
    }
    
    self.maskView = [[UIView alloc]init];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_top).mas_offset(44);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.resultView = [[SignInPlaceSearchResultView alloc]init];
    WEAK_SELF
    [self.resultView setSelectBlock:^(BMKPoiInfo *info) {
        STRONG_SELF
        [self.headerView updateWithPoiInfo:info];
        [self.headerView endSearching];
    }];
    [self.resultView setSearchMoreBlock:^{
        STRONG_SELF
        [self.headerView searchNextPage];
    }];
    [self.view addSubview:self.resultView];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.maskView.mas_top);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.emptyView = [[PlaceSearchEmptyView alloc]init];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.maskView.mas_top);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.resultView.hidden = YES;
    self.emptyView.hidden = YES;
}
- (void)searchFieldDidEndEditting {
    if ([UIDevice currentDevice].systemVersion.floatValue<11) {
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(44+200*kPhoneWidthRatio);
        }];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.maskView removeFromSuperview];
    [self.resultView removeFromSuperview];
    [self.emptyView removeFromSuperview];
}
- (void)nearbySearchUpdated:(NSArray<BMKPoiInfo *> *)results {
    self.results = results;
    self.currentIndex = 0;
    [self.tableView reloadData];
}
- (void)searchResultUpdated:(NSArray<BMKPoiInfo *> *)results withKey:(NSString *)key {
    if (results.count > 0) {
        [self.resultView updateWithResults:results withKey:key];
        self.resultView.hidden = NO;
        self.emptyView.hidden = YES;
    }else if (key.length > 0){
        self.resultView.hidden = YES;
        self.emptyView.hidden = NO;
    }else {
        self.resultView.hidden = YES;
        self.emptyView.hidden = YES;
    }
}
- (void)nextPageSearchResultUpdated:(NSArray<BMKPoiInfo *> *)results {
    [self.resultView updateWithNextPageResults:results];
}
@end
