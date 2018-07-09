//
//  HubeiSubjectSelectionViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HubeiSubjectSelectionViewController.h"
#import "CascadeItemCell.h"

NSString * const kStageSubjectDidSelectNotification = @"kStageSubjectDidSelectNotification";
NSString * const kStageItemKey = @"kStageItemKey";
NSString * const kSubjectItemKey = @"kSubjectItemKey";

@interface HubeiSubjectSelectionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation HubeiSubjectSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.currentStage.name;
    WEAK_SELF
    [self nyx_setupRightWithTitle:@"确定" action:^{
        STRONG_SELF
        NSDictionary *info = @{kStageItemKey:self.currentStage,
                               kSubjectItemKey:self.currentStage.subjects[self.selectedIndex]
                               };
        [[NSNotificationCenter defaultCenter]postNotificationName:kStageSubjectDidSelectNotification object:nil userInfo:info];
    }];
    for (Subject *item in self.currentStage.subjects) {
        if (self.currentSubject.subjectID.integerValue == item.subjectID.integerValue) {
            self.selectedIndex = [self.currentStage.subjects indexOfObject:item];
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
    return self.currentStage.subjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CascadeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CascadeItemCell"];
    Subject *subject = self.currentStage.subjects[indexPath.row];
    cell.name = subject.name;
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
