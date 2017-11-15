//
//  CourseResourceViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseResourceViewController.h"
#import "CourseResourceFetcher.h"
#import "CourseResourceCell.h"
#import "ResourceDisplayViewController.h"
#import "GetResourceDetailRequest.h"

@interface CourseResourceViewController ()
@property (nonatomic, strong) GetResourceDetailRequest *request;
@end

@implementation CourseResourceViewController

- (void)viewDidLoad {
    CourseResourceFetcher *fetcher = [[CourseResourceFetcher alloc]init];
    fetcher.courseId = self.courseId;
    self.dataFetcher = fetcher;
    self.bNeedHeader = NO;
    self.bNeedFooter = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.navigationController.navigationBarHidden) {
        return;
    }
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 71;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CourseResourceCell class] forCellReuseIdentifier:@"CourseResourceCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseResourceCell"];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourseResourceRequestItem_elements *data = self.dataArray[indexPath.row];
    [self requestResourceDetailWithResId:data.resId];
}

- (void)requestResourceDetailWithResId:(NSString *)resId {
    [self.request stopRequest];
    self.request = [[GetResourceDetailRequest alloc]init];
    self.request.resId = resId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[GetResourceDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        GetResourceDetailRequestItem *item = (GetResourceDetailRequestItem *)retItem;
        ResourceDisplayViewController *vc = [[ResourceDisplayViewController alloc]init];
        if (item.data.type.integerValue > 0) {
            vc.urlString = item.data.url;
            vc.name = item.data.resName;
        }else {
            vc.urlString = item.data.ai.resName;
            vc.name = item.data.ai.previewUrl;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
