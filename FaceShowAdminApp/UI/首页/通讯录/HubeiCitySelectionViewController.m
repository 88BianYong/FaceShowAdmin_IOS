//
//  HubeiCitySelectionViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HubeiCitySelectionViewController.h"
#import "CascadeItemCell.h"
#import "HubeiDistrictSelectionViewController.h"

@interface HubeiCitySelectionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation HubeiCitySelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.currentProvince.name;
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"下一步" action:^{
        STRONG_SELF
        HubeiDistrictSelectionViewController *vc = [[HubeiDistrictSelectionViewController alloc]init];
        vc.currentProvince = self.currentProvince;
        vc.currentCity = self.currentProvince.sub[self.selectedIndex];
        vc.currentDistrict = self.currentDistrict;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    for (Area *item in self.currentProvince.sub) {
        if (self.currentCity.areaID.integerValue == item.areaID.integerValue) {
            self.selectedIndex = [self.currentProvince.sub indexOfObject:item];
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
    return self.currentProvince.sub.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CascadeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CascadeItemCell"];
    Area *area = self.currentProvince.sub[indexPath.row];
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
