//
//  HubeiDistrictSelectionViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HubeiDistrictSelectionViewController.h"
#import "CascadeItemCell.h"

NSString * const kAreaDidSelectNotification = @"kAreaDidSelectNotification";
NSString * const kProvinceItemKey = @"kProvinceItemKey";
NSString * const kCityItemKey = @"kCityItemKey";
NSString * const kDistrictItemKey = @"kDistrictItemKey";

@interface HubeiDistrictSelectionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation HubeiDistrictSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.currentCity.name;
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"确定" action:^{
        STRONG_SELF
        NSDictionary *info = @{kProvinceItemKey:self.currentProvince,
                               kCityItemKey:self.currentCity,
                               kDistrictItemKey:self.currentCity.sub[self.selectedIndex]
                               };
        [[NSNotificationCenter defaultCenter]postNotificationName:kAreaDidSelectNotification object:nil userInfo:info];
    }];
    for (Area *item in self.currentCity.sub) {
        if (self.currentDistrict.areaID.integerValue == item.areaID.integerValue) {
            self.selectedIndex = [self.currentCity.sub indexOfObject:item];
            break;
        }
    }
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.rowHeight = 45;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[CascadeItemCell class] forCellReuseIdentifier:@"CascadeItemCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentCity.sub.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CascadeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CascadeItemCell"];
    Area *area = self.currentCity.sub[indexPath.row];
    cell.name = area.name;
    cell.isCurrent = self.selectedIndex==indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
    return header;
}

@end
