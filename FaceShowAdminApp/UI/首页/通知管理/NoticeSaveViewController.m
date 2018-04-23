//
//  NoticeSaveViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeSaveViewController.h"
#import "NoticeSaveTitleCell.h"
#import "NoticeSaveContentCell.h"
#import "NoticeSaveImageCell.h"
#import "FSDefaultHeaderFooterView.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "YXImagePickerController.h"
#import "QADataManager.h"
#import "FDActionSheetView.h"
#import "AlertView.h"

@interface NoticeSaveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) NoticeSaveTitleCell *titleCell;
@property (nonatomic, strong) NoticeSaveContentCell *contentCell;
@property (nonatomic, strong) NoticeSaveImageCell *imageCell;
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;
@property (nonatomic, strong) NoticeSaveRequest *saveRequest;
@property (nonatomic, strong) AlertView *alertView;
@end

@implementation NoticeSaveViewController
- (void)dealloc {
    DDLogDebug(@"release========>>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布通知";
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
    self.titleCell = [[NoticeSaveTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoticeSaveTitleCell"];
    self.contentCell = [[NoticeSaveContentCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"NoticeSaveContentCell"];
    self.imageCell = [[NoticeSaveImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoticeSaveImageCell"];
    WEAK_SELF
    [[self.imageCell.chooseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self.titleCell.textField resignFirstResponder];
        [self.contentCell.textView resignFirstResponder];
        [self showAlertView];
        [TalkingData trackEvent:@"通知中添加照片"];
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
        [self.contentCell.textView resignFirstResponder];
    }];
    [self.imageCell.contentView addGestureRecognizer:tapGestureRecognizer];
    [self.tableView registerClass:[FSDefaultHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FSDefaultHeaderFooterView"];
    [self.view addSubview:self.tableView];
    self.imagePickerController = [[YXImagePickerController alloc] init];
    [self setupNavRightView];
    [self nyx_setupLeftWithImageName:@"返回页面按钮正常态" highlightImageName:@"返回页面按钮点击态" action:^{
        STRONG_SELF
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }];
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
                    if (@available(iOS 11.0, *)) {
                        make.bottom.mas_equalTo(view.mas_safeAreaLayoutGuideBottom);
                    } else {
                        make.bottom.mas_equalTo(0);
                    }
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
            [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera completion:^(UIImage *selectedImage) {
                STRONG_SELF
                [self presentNextPublishViewController:selectedImage];
            }];
        }else if (integer == 2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary completion:^(UIImage *selectedImage) {
                    STRONG_SELF
                    [self presentNextPublishViewController:selectedImage];
                }];
            });
            
        }
        [self.alertView hide];
    };
}
//- (void)showAlertView {
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    WEAK_SELF
//    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        STRONG_SELF
//    }];
//    [alertVC addAction:cancleAction];
//    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        STRONG_SELF
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera
//                                             rootViewController:self completion:^(UIImage *selectedImage) {
//                                                 STRONG_SELF
//                                                 [self presentNextPublishViewController:selectedImage];
//                                             }];
//        });
//    }];
//    [alertVC addAction:cameraAction];
//    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        STRONG_SELF
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary rootViewController:self completion:^(UIImage *selectedImage) {
//                STRONG_SELF
//                [self presentNextPublishViewController:selectedImage];
//            }];
//        });
//
//    }];
//    [alertVC addAction:photoAction];
//    
//    UIViewController *visibleVC = [self nyx_visibleViewController];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        alertVC.popoverPresentationController.sourceView = visibleVC.view;
//        alertVC.popoverPresentationController.sourceRect = CGRectMake(200,100,200,200);
//    }
//    
//    [visibleVC presentViewController:alertVC animated:YES completion:nil];
//}
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
        }else {
            [self requestForNoticeSave:nil];
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
    RACSignal *contentSignal =
    [self.contentCell.textView.rac_textSignal
     map:^id(NSString *text) {
         @strongify(self);
         return @([self isContentLength:text]);
     }];
    
    RACSignal *activeSignal =
//    [RACSignal combineLatest:@[titleSignal,contentSignal,RACObserve(self.imageCell, isContainImage)]
//                      reduce:^id(NSNumber *titleValid, NSNumber *contentValid, NSNumber *image) {
//                          return @([titleValid boolValue] && [contentValid boolValue] && [image boolValue]);
//                      }];
    [RACSignal combineLatest:@[titleSignal,contentSignal]
                      reduce:^id(NSNumber *titleValid, NSNumber *contentValid) {
                          return @([titleValid boolValue] && [contentValid boolValue]);
                      }];
    [activeSignal subscribeNext:^(NSNumber *signupActive) {
        STRONG_SELF
         self.navRightBtn.enabled = [signupActive boolValue];
    }];
}

- (BOOL)isTitleLength:(NSString *)contentString {
    return (contentString.length > 0 && contentString.length <= 20) ? YES : NO;
}
- (BOOL)isContentLength:(NSString *)contentString {
    return  (contentString.length > 0 && contentString.length <= 200) ? YES : NO;
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
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.titleCell;
    }else if (indexPath.row == 1) {
        return self.contentCell;
    }else {
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
    }else if (indexPath.row == 1) {
        return 220.0f;
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
    [self.view.window nyx_startLoading];
    WEAK_SELF
    [QADataManager uploadFile:self.imageCell.photoImageView.image fileName:fileName completeBlock:^(QAFileUploadSecondStepRequestItem *item, NSError *error) {
        STRONG_SELF
        [self.view.window nyx_stopLoading];
        if (item.result.resid == nil){
            [self.view nyx_showToast:@"发布失败请重试"];
        }else {
            [self requestForNoticeSave:item.result];
        }
    }];
}
- (void)requestForNoticeSave:(QAFileUploadSecondStepRequestItem_result *)result{
    //@白东方 priviewUrl=`http://upload.ugc.yanxiu.com/img/${markfile.md5}.${markfile.ext}?from=${config.from}&resId=${markfile.resId}`;
    [self.saveRequest stopRequest];
    self.saveRequest = [[NoticeSaveRequest alloc] init];
    self.saveRequest.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    self.saveRequest.title = self.titleCell.textField.text;
    self.saveRequest.content = self.contentCell.textView.text;
    if (result != nil) {
        self.saveRequest.url = [NSString stringWithFormat:@"http://upload.ugc.yanxiu.com/img/%@.jpg?from=%@&resId=%@",result.md5,result.from,result.resid];
    }
    [self.view.window nyx_startLoading];
    WEAK_SELF
    [self.saveRequest startRequestWithRetClass:[NoticeSaveRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view.window nyx_stopLoading];
        NoticeSaveRequestItem *item = retItem;
        if (item.data == nil) {
            [self.view nyx_showToast:@"发布失败请重试"];
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//图片转换时间
                [self.view nyx_stopLoading];
                BLOCK_EXEC(self.noticeSaveBlock);
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            });
        }
    }];
}

@end
