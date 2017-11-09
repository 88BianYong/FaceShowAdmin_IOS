//
//  MyInfoViewController.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MyInfoViewController.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "UserInfoHeaderCell.h"
#import "UserInfoDefaultCell.h"
#import "FSDefaultHeaderFooterView.h"
#import "YXImagePickerController.h"
#import "UploadHeadImgRequest.h"
#import "UpdateTextInfoViewController.h"
#import "AlertView.h"
#import "FDActionSheetView.h"
#import "UpdateUserInfoRequest.h"

@interface MyInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) NSMutableArray *contentMutableArray;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;

@property (nonatomic, strong) UpdateUserInfoRequest *updateUserInfoRequest;
@property (nonatomic, strong) GetUserInfoRequest *userInfoRequest;
@property (nonatomic, strong) UploadHeadImgRequest *uploadHeadImgRequest;
@end

@implementation MyInfoViewController

- (void)dealloc {
    DDLogDebug(@"release========>>%@",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的资料";
    self.contentMutableArray =
    [@[[@{@"title":@"姓名",@"content": [UserManager sharedInstance].userModel.realName?:@"暂无",@"next":@(YES)} mutableCopy],
       [@{@"title":@"联系电话",@"content":[UserManager sharedInstance].userModel.mobilePhone?:@"暂无"} mutableCopy],
       [@{@"title":@"性别",@"content":[UserManager sharedInstance].userModel.sexName?:@"暂无",@"next":@(YES)} mutableCopy],
       [@{@"title":@"学段",@"content":[UserManager sharedInstance].userModel.stageName?:@"暂无"} mutableCopy],
       [@{@"title":@"学科",@"content":[UserManager sharedInstance].userModel.subjectName?:@"暂无"} mutableCopy],
       [@{@"title":@"学校",@"content": [UserManager sharedInstance].userModel.school ?:@"暂无",@"next":@(YES)} mutableCopy]] mutableCopy];
    [self setupUI];
    [self setupLayout];
    [self requestForUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark - get
- (YXImagePickerController *)imagePickerController
{
    if (_imagePickerController == nil) {
        _imagePickerController = [[YXImagePickerController alloc] init];
    }
    return _imagePickerController;
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.tableView registerClass:[UserInfoHeaderCell class] forCellReuseIdentifier:@"UserInfoHeaderCell"];
    [self.tableView registerClass:[UserInfoDefaultCell class] forCellReuseIdentifier:@"UserInfoDefaultCell"];
    [self.tableView registerClass:[FSDefaultHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FSDefaultHeaderFooterView"];
    [self.view addSubview:self.tableView];
}
- (void)setupLayout {
    //containerView
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)showAlertViewWithIndex:(NSIndexPath *)index isImagePicker:(BOOL)isImagePicker {
    FDActionSheetView *actionSheetView = [[FDActionSheetView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    actionSheetView.titleArray = isImagePicker ? @[@{@"title":@"拍照"}, @{@"title":@"从相册选择"}] : @[@{@"title":@"男"}, @{@"title":@"女"}];
    self.alertView = [[AlertView alloc] init];
    self.alertView.backgroundColor = [UIColor clearColor];
    self.alertView.hideWhenMaskClicked = YES;
    self.alertView.contentView = actionSheetView;
    WEAK_SELF
    [self.alertView setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3 animations:^{
            [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left);
                make.right.equalTo(view.mas_right);
                make.top.equalTo(view.mas_bottom);
                make.height.mas_offset(155.0f);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [self.alertView showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.right.equalTo(view.mas_right);
            make.top.equalTo(view.mas_bottom);
            make.height.mas_offset(155.0f );
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left);
                    make.right.equalTo(view.mas_right);
                    make.bottom.equalTo(view.mas_bottom);
                    make.height.mas_offset(155.0f);
                }];
                [view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        });
    }];
    actionSheetView.actionSheetBlock = ^(NSInteger integer) {
        STRONG_SELF
        if (isImagePicker) {
            if (integer == 1) {
                [self pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
                
            } else if (integer == 2) {
                [self pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            [self.alertView hide];
        } else {
            if ([UserManager sharedInstance].userModel.sexID.integerValue == integer%2) {
                [self.alertView hide];
                return;
            }
            [self updateUserInfoWithSexID:integer%2 sexIndex:index];
        }
    };
}

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    WEAK_SELF
    [self.imagePickerController pickImageWithSourceType:sourceType rootViewController:nil completion:^(UIImage *selectedImage) {
        STRONG_SELF
        [self updateWithHeaderImage:selectedImage];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 75.5f;
    }else{
        return 45.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 5.0f : 0.00001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FSDefaultHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FSDefaultHeaderFooterView"];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        [self showAlertViewWithIndex:indexPath isImagePicker:YES];
    }else if (indexPath.section == 3) {
        [self showAlertViewWithIndex:indexPath isImagePicker:NO];
    }else if (indexPath.section == 1 || indexPath.section == 6) {
        UpdateTextInfoViewController *vc = [[UpdateTextInfoViewController alloc]init];
        vc.type = indexPath.section == 1 ? 0 : 1;
        WEAK_SELF
        vc.updateTextInfoSucceedBlock = ^{
            STRONG_SELF
            if (indexPath.section == 1) {
                [self.contentMutableArray[0] setValue:[UserManager sharedInstance].userModel.realName forKey:@"content"];
            } else {
                [self.contentMutableArray[5] setValue:[UserManager sharedInstance].userModel.school forKey:@"content"];
            }
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataScource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contentMutableArray.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserInfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoHeaderCell" forIndexPath:indexPath];
        [cell reload];
        return cell;
    }else {
        UserInfoDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoDefaultCell" forIndexPath:indexPath];
        cell.contenDictionary = self.contentMutableArray[indexPath.section - 1];
        return cell;
    }
}
#pragma mark - request
- (void)requestForUserInfo{
    GetUserInfoRequest *request = [[GetUserInfoRequest alloc] init];
    [self.view nyx_startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[GetUserInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        GetUserInfoRequestItem *item = retItem;
        if (item.data != nil) {
            [[UserManager sharedInstance].userModel updateFromUserInfo:item.data];
            self.contentMutableArray[0][@"content"] = [UserManager sharedInstance].userModel.realName?:@"暂无";
            self.contentMutableArray[1][@"content"] = [UserManager sharedInstance].userModel.mobilePhone?:@"暂无";
            self.contentMutableArray[2][@"content"] = [UserManager sharedInstance].userModel.sexName?:@"暂无";
            self.contentMutableArray[3][@"content"] = [UserManager sharedInstance].userModel.stageName?:@"暂无";
            self.contentMutableArray[4][@"content"] = [UserManager sharedInstance].userModel.subjectName?:@"暂无";
            self.contentMutableArray[5][@"content"] = [UserManager sharedInstance].userModel.school?:@"暂无";
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpdateUserInfoSucceedNotification" object:nil];
        }
    }];
    self.userInfoRequest = request;
}

- (void)updateUserInfoWithSexID:(NSInteger)sexID sexIndex:(NSIndexPath *)index {
    [self.updateUserInfoRequest stopRequest];
    self.updateUserInfoRequest = [[UpdateUserInfoRequest alloc]init];
    self.updateUserInfoRequest.sex = [NSString stringWithFormat:@"%@", @(sexID)];
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.updateUserInfoRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [UserManager sharedInstance].userModel.sexName = sexID ? @"男" : @"女";
        [UserManager sharedInstance].userModel.sexID = [NSString stringWithFormat:@"%@", @(sexID)];
        [[UserManager sharedInstance]saveData];
        [self.alertView hide];
        [self.contentMutableArray[2] setValue:[UserManager sharedInstance].userModel.sexName forKey:@"content"];
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)updateWithHeaderImage:(UIImage *)image
{
    if (!image) {
        return;
    }
    NSData *data = [UIImage compressionImage:image limitSize:2*1024*1024];
    [self.uploadHeadImgRequest stopRequest];
    self.uploadHeadImgRequest = [[UploadHeadImgRequest alloc] init];
    [self.uploadHeadImgRequest.request setData:data
                                  withFileName:@"head.jpg"
                                andContentType:nil
                                        forKey:@"easyfile"];
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.uploadHeadImgRequest startRequestWithRetClass:[UploadHeadImgItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        UploadHeadImgItem *item = retItem;
        if (error) {
            [self.view nyx_stopLoading];
            
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        if (item.tplData.data.count != 0) {
            UploadHeadImgItem_TplData_Data *data = item.tplData.data[0];
            [self requestForUploadAvatar:data.url?:data.shortUrl];
        } else {
            [self.view nyx_stopLoading];
            [self.view nyx_showToast:item.tplData.message];
        }
    }];
}
- (void)requestForUploadAvatar:(NSString *)url {
    [self.updateUserInfoRequest stopRequest];
    self.updateUserInfoRequest = [[UpdateUserInfoRequest alloc] init];
    self.updateUserInfoRequest.avatar = url;
    WEAK_SELF
    [self.updateUserInfoRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (!error) {
            [UserManager sharedInstance].userModel.avatarUrl = url;
            [[UserManager sharedInstance] saveData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpdateUserInfoSucceedNotification" object:nil];
        }
    }];
}

@end
