//
//  HubeiProvinceSelectionViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HubeiProvinceSelectionViewController.h"
#import "CascadeItemCell.h"
#import "HubeiCitySelectionViewController.h"

@interface HubeiProvinceSelectionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation HubeiProvinceSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择省份";
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"下一步" action:^{
        STRONG_SELF
        HubeiCitySelectionViewController *vc = [[HubeiCitySelectionViewController alloc]init];
        vc.currentProvince = [AreaManager sharedInstance].areaModel.data[self.selectedIndex];
        vc.currentCity = self.currentCity;
        vc.currentDistrict = self.currentDistrict;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    for (Area *item in [AreaManager sharedInstance].areaModel.data) {
        if (self.currentProvince.areaID.integerValue == item.areaID.integerValue) {
            self.selectedIndex = [[AreaManager sharedInstance].areaModel.data indexOfObject:item];
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
    return [AreaManager sharedInstance].areaModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CascadeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CascadeItemCell"];
    Area *area = [AreaManager sharedInstance].areaModel.data[indexPath.row];
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
