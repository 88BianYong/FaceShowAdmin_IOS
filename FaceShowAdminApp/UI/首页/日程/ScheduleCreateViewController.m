//
//  ScheduleCreateViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScheduleCreateViewController.h"
#import "ScheduleCreateTitleCell.h"
#import "ScheduleCreateImageCell.h"
#import "FSDefaultHeaderFooterView.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "YXImagePickerController.h"
#import "QADataManager.h"
#import "FDActionSheetView.h"
#import "AlertView.h"
#import "ScheduleCreateRequest.h"
#import "ScheduleUpdateRequest.h"
@interface ScheduleCreateViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) ScheduleCreateTitleCell *titleCell;
@property (nonatomic, strong) ScheduleCreateImageCell *imageCell;
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;

@property (nonatomic, strong) AlertView *alertView;

@property (nonatomic, strong) ScheduleCreateRequest *createRequest;
@property (nonatomic, strong) ScheduleUpdateRequest *updateRequest;
@end

@implementation ScheduleCreateViewController

- (void)dealloc {
    DDLogDebug(@"release========>>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布日程";
    [self setupUI];
    [self setupLayout];
    [self addNotification];
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.titleCell = [[ScheduleCreateTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ScheduleCreateTitleCell"];
    self.imageCell = [[ScheduleCreateImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ScheduleCreateImageCell"];
    WEAK_SELF
    [[self.imageCell.chooseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self.titleCell.textField resignFirstResponder];
        [self showAlertView];
    }];
    [[self.imageCell.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.imageCell.isContainImage = NO;
        self.imageCell.photoImageView.image = nil;
    }];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [[tapGestureRecognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
        STRONG_SELF
        [self.titleCell.textField resignFirstResponder];
    }];
    [self.imageCell.contentView addGestureRecognizer:tapGestureRecognizer];
    [self.tableView registerClass:[FSDefaultHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FSDefaultHeaderFooterView"];
    [self.view addSubview:self.tableView];
    self.imagePickerController = [[YXImagePickerController alloc] init];
    [self setupNavRightView];
    [self nyx_setupLeftWithImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 30, 30)] action:^{
        STRONG_SELF
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        if (self.element == nil) {
            BLOCK_EXEC(self.reloadDateBlock,nil);
        };
    }];
    
    if (self.element != nil) {
        self.imageCell.photoImageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
        self.titleCell.textField.text = self.element.subject;
        UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朋友圈一张图加载失败图片"]];
        [self.imageCell.photoImageView addSubview:placeholderImageView];
        [placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imageCell.photoImageView);
        }];
        [self.imageCell.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.element.imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            STRONG_SELF
            if (error == nil) {
                [placeholderImageView removeFromSuperview];
                self.imageCell.photoImageView.backgroundColor = [UIColor clearColor];
            }
        }];
        self.imageCell.isContainImage = YES;
    }
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)showAlertView {
    FDActionSheetView *actionSheetView = [[FDActionSheetView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    actionSheetView.titleArray = @[@{@"title":@"拍照"},
                                   @{@"title":@"相册"}];
    self.alertView = [[AlertView alloc]init];
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
        if (integer == 1) {
            [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera
                                             rootViewController:self completion:^(UIImage *selectedImage) {
                                                 STRONG_SELF
                                                 [self presentNextPublishViewController:selectedImage];
                                             }];
            
        }else if (integer == 2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary rootViewController:self completion:^(UIImage *selectedImage) {
                    STRONG_SELF
                    [self presentNextPublishViewController:selectedImage];
                }];
            });
            
        }
        [self.alertView hide];
    };
}
- (void)presentNextPublishViewController:(UIImage *)image {
    self.imageCell.photoImageView.image = image;
    self.imageCell.isContainImage = YES;
}
- (void)setupNavRightView {
    self.navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navRightBtn.frame = CGRectMake(0, 0, 50, 30);
    self.navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navRightBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.navRightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [self.navRightBtn setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [self.navRightBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    self.navRightBtn.enabled = NO;
    WEAK_SELF
    [[self.navRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.imageCell.isContainImage) {
            [self requestForUploadImage];
        }
    }];
    [self nyx_setupRightWithCustomView:self.navRightBtn];
}
- (void)addNotification {
    @weakify(self);
    RACSignal *titleSignal =
    [self.titleCell.textField.rac_textSignal
     map:^id(NSString *text) {
         @strongify(self);
         return @([self isTitleLength:text]);
     }];
    RACSignal *activeSignal =
        [RACSignal combineLatest:@[titleSignal,RACObserve(self.imageCell, isContainImage)]
                          reduce:^id(NSNumber *titleValid, NSNumber *image) {
                              return @([titleValid boolValue] && [image boolValue]);
                          }];
    [activeSignal subscribeNext:^(NSNumber *signupActive) {
        STRONG_SELF
        self.navRightBtn.enabled = [signupActive boolValue];
    }];
}

- (BOOL)isTitleLength:(NSString *)contentString {
    return (contentString.length > 0 && contentString.length <= 20) ? YES : NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.titleCell;
    }else{
        return self.imageCell;
    }
}
#pragma mark - UITableViewDataScore
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FSDefaultHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FSDefaultHeaderFooterView"];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60.0f;
    }else {
        return SCREEN_WIDTH;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - request
- (void)requestForUploadImage {
    if (self.titleCell.textField.text.length > 20) {
        [self.view nyx_showToast:@"通知标题最多20字"];
        return;
    }
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg",[UserManager sharedInstance].userModel.userID, (int)interval];
    [self.view nyx_startLoading];
    WEAK_SELF
    [QADataManager uploadFile:self.imageCell.photoImageView.image fileName:fileName completeBlock:^(QAFileUploadSecondStepRequestItem *item, NSError *error) {
        STRONG_SELF
        if (item.result.resid == nil){
            [self.view nyx_stopLoading];
            [self.view nyx_showToast:@"发布失败请重试"];
        }else {
            if (self.element == nil) {
                [self requestForScheduleCreate:item.result];
            }else {
                [self requestForScheduleUpdate:item.result];
            }
        }
    }];
}
- (void)requestForScheduleCreate:(QAFileUploadSecondStepRequestItem_result *)result{
    self.createRequest = [[ScheduleCreateRequest alloc] init];
    self.createRequest.subject = self.titleCell.textField.text;
    self.createRequest.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    self.createRequest.imageUrl = [NSString stringWithFormat:@"http://upload.ugc.yanxiu.com/img/%@.jpg?from=%@&resId=%@",result.md5,result.from,result.resid];
    WEAK_SELF
    [self.createRequest startRequestWithRetClass:[ScheduleCreateRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        ScheduleUpdateRequestItem *item = retItem;
        if (item.data == nil) {
            [self.view nyx_showToast:@"发布失败请重试"];
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//图片转换时间
                [self.view nyx_stopLoading];
                BLOCK_EXEC(self.reloadDateBlock,item.data.schedule);
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            });
        }
    }];
}
- (void)requestForScheduleUpdate:(QAFileUploadSecondStepRequestItem_result *)result {
    self.updateRequest = [[ScheduleUpdateRequest alloc] init];
    self.updateRequest.scheduleId = self.element.elementId;
    self.updateRequest.subject = self.titleCell.textField.text;
    self.updateRequest.imageUrl = [NSString stringWithFormat:@"http://upload.ugc.yanxiu.com/img/%@.jpg?from=%@&resId=%@",result.md5,result.from,result.resid];
    WEAK_SELF
    [self.updateRequest startRequestWithRetClass:[ScheduleUpdateRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        ScheduleUpdateRequestItem *item = retItem;
        if (item.data == nil) {
            [self.view nyx_showToast:@"发布失败请重试"];
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//图片转换时间
                [self.view nyx_stopLoading];
                BLOCK_EXEC(self.reloadDateBlock,item.data.schedule);
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            });
        }
    }];
}

@end
