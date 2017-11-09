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
@interface ScheduleDetailViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) ScheduleDeleteRequest *deleteRequest;




@end

@implementation ScheduleDetailViewController

- (void)dealloc {
    DDLogDebug(@"release========>>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"日程管理";
    [self setupUI];
    [self setupLayout];
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
            self.titleLabel.text = self.element.subject;
            self.imageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
            UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朋友圈一张图加载失败图片"]];
            [self.imageView addSubview:placeholderImageView];
            [placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.imageView);
            }];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.element.imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                STRONG_SELF
                if (error == nil) {
                    [self.imageView removeSubviews];
                    self.imageView.backgroundColor = [UIColor clearColor];
                }
            }];
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
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = [UIScreen mainScreen].bounds.size;
    [self.view addSubview:self.scrollView];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -360, self.view.bounds.size.width, 360.0f)];
    topView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.scrollView addSubview:topView];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.containerView];
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.containerView addSubview:self.topView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.containerView addSubview:self.lineView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.titleLabel.text = self.element.subject;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.containerView addSubview:self.titleLabel];
    WEAK_SELF
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    [self.containerView addSubview:self.imageView];
    UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朋友圈一张图加载失败图片"]];
    [self.imageView addSubview:placeholderImageView];
    [placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
    }];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.element.imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        STRONG_SELF
        if (error == nil) {
            [placeholderImageView removeFromSuperview];
            self.imageView.backgroundColor = [UIColor clearColor];
        }
    }];
    [self setupNavRightView];
}

- (void)setupNavRightView {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame = CGRectMake(0, 0, 65, 30);
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navRightBtn setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"扫一扫icon-正常态"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"扫一扫icon-点击态"] forState:UIControlStateHighlighted];
    navRightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -24, 0, 14);
    navRightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 38, 0, -28);
    WEAK_SELF
    [[navRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self showAlertView];
    }];
    [self nyx_setupRightWithCustomView:navRightBtn];
}
- (void)showAlertView {
    FDActionSheetView *actionSheetView = [[FDActionSheetView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    actionSheetView.titleArray = @[@{@"title":@"修改"},
                                   @{@"title":@"删除"}];
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
            [self createScheduleViewController];
        }else if (integer == 2) {
            [self requestForDeleteSchedule];
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
        self.titleLabel.text = self.element.subject;
        self.imageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
        UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朋友圈一张图加载失败图片"]];
        [self.imageView addSubview:placeholderImageView];
        [placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imageView);
        }];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.element.imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            STRONG_SELF
            if (error == nil) {
                [self.imageView removeSubviews];
                self.imageView.backgroundColor = [UIColor clearColor];
            }
        }];
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

- (void)setupLayout {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.scrollView.mas_top);
        make.height.mas_offset(SCREEN_WIDTH - 30.0f + 80.0f);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.containerView.mas_top);
        make.height.mas_offset(5.0f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(25.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-25.0f);
        make.top.equalTo(self.topView.mas_bottom).offset(20.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f);
        make.height.mas_offset(1.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(21.0f);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f);
        make.top.equalTo(self.lineView.mas_bottom).offset(21.0f);
        make.width.equalTo(self.imageView.mas_height);
    }];
}

@end
