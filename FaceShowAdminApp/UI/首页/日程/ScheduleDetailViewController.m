//
//  ScheduleDetailViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/9.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScheduleDetailViewController.h"
#import "FDActionSheetView.h"
#import "AlertView.h"
#import "ScheduleCreateViewController.h"
#import "ScheduleDeleteRequest.h"
#import "ShowPhotosViewController.h"
#import "FSDataMappingTable.h"
@interface ScheduleDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) ScheduleDeleteRequest *deleteRequest;
@end

@implementation ScheduleDetailViewController

- (void)dealloc {
    DDLogDebug(@"release========>>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.element.subject;
    [self setupUI];
    if (self.element == nil) {
        ScheduleCreateViewController *VC = [[ScheduleCreateViewController alloc] init];
        FSNavigationController *nav = [[FSNavigationController alloc] initWithRootViewController:VC];
        WEAK_SELF
        VC.reloadDateBlock = ^(ScheduleDetailRequestItem_Data_Schedules_Elements *item) {
            STRONG_SELF
            if (item == nil) {
                [self.navigationController popViewControllerAnimated:NO];
                return;
            }
            self.element = item;
            self.navigationItem.title = self.element.subject;
            [self loadWebViewWithUrl:self.element.imageUrl ? self.element.imageUrl : self.element.attachmentInfo.previewUrl];
        };
        [[self nyx_visibleViewController] presentViewController:nav animated:YES completion:^{
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - setupUI
- (void)setupUI {
    WEAK_SELF
    self.webview = [[UIWebView alloc]init];
    self.webview.scalesPageToFit = YES;
    self.webview.delegate = self;
    [self loadWebViewWithUrl:self.element.imageUrl ? self.element.imageUrl : self.element.attachmentInfo.previewUrl];
    [self.view addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(15);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-15);
        } else {
            make.bottom.mas_equalTo(-15);
        }
    }];
    
    [self nyx_setupRightWithImageName:@"更多操作按钮正常态" highlightImageName:@"更多操作按钮点击态" action:^{
        STRONG_SELF
        [self showAlertView];
    }];
}

- (void)showAlertView {
    FDActionSheetView *actionSheetView = [[FDActionSheetView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    NSArray *titleArray;
    if ([FSDataMappingTable ResourceTypeWithKey:self.element.attachmentInfo.resType] == ResourceType_Image || (!self.element.attachmentInfo && self.element.imageUrl)) {
        titleArray = @[@{@"title":@"修改"},
                       @{@"title":@"删除"}];
    }else {
        titleArray = @[@{@"title":@"删除"}];
    }
    actionSheetView.titleArray = titleArray;
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
                make.height.mas_offset(50 * titleArray.count + 55);
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
            make.height.mas_offset(50 * titleArray.count + 55);
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
                    make.height.mas_offset(50 * titleArray.count + 55);
                }];
                [view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        });
    }];
    actionSheetView.actionSheetBlock = ^(NSInteger integer) {
        STRONG_SELF
        if (titleArray.count == 1) {
            [TalkingData trackEvent:@"删除日程"];
            [self requestForDeleteSchedule];
        }else {
            if (integer == 1) {
                [self createScheduleViewController];
            }else if (integer == 2) {
                [TalkingData trackEvent:@"删除日程"];
                [self requestForDeleteSchedule];
            }
        }
        [self.alertView hide];
    };
}
- (void)createScheduleViewController {
    ScheduleCreateViewController *VC = [[ScheduleCreateViewController alloc] init];
    FSNavigationController *nav = [[FSNavigationController alloc] initWithRootViewController:VC];
    VC.element = self.element;
    WEAK_SELF
    VC.reloadDateBlock = ^(ScheduleDetailRequestItem_Data_Schedules_Elements *item) {
        STRONG_SELF
        self.element = item;
        self.navigationItem.title = self.element.subject;
        [self loadWebViewWithUrl:self.element.imageUrl ? self.element.imageUrl : self.element.attachmentInfo.previewUrl];
    };
    [[self nyx_visibleViewController] presentViewController:nav animated:YES completion:^{
    }];
}
- (void)requestForDeleteSchedule {
    self.deleteRequest = [[ScheduleDeleteRequest alloc] init];
    self.deleteRequest.scheduleId = self.element.elementId;
    [self.view nyx_startLoading];
    WEAK_SELF
    [self.deleteRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - UIWebView
- (void)loadWebViewWithUrl:(NSString *)url {
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [self.webview loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.view nyx_startLoading];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view nyx_stopLoading];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view nyx_stopLoading];
    [self.view nyx_showToast:@"加载失败"];
}

@end
