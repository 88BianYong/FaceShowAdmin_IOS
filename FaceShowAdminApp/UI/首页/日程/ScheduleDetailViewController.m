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
@interface ScheduleDetailViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *headerBackImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) AlertView *alertView;

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
    
    self.headerBackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"日常管理背景图"]];
    [self.containerView addSubview:self.headerBackImage];
    
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
    [self nyx_setupRightWithImageName:@"更多操作按钮正常态" highlightImageName:@"更多操作按钮点击态" action:^{
        STRONG_SELF
        [self showAlertView];
    }];
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
            [self createScheduleViewController];
        }else if (integer == 2) {
            [TalkingData trackEvent:@"删除日程"];
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
    
    [self.headerBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(100);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f);
        make.top.equalTo(self.headerBackImage.mas_bottom);
        make.width.equalTo(self.imageView.mas_height);
    }];
}
- (void)tapAction:(UITapGestureRecognizer *)sender {
    ShowPhotosViewController *showPhotosVC = [[ShowPhotosViewController alloc] init];
    PreviewPhotosModel *model = [[PreviewPhotosModel alloc] init];
    model.original = self.element.imageUrl;
    NSMutableArray *photoArr = [NSMutableArray arrayWithObject:model];
    showPhotosVC.animateRect = [self.view convertRect:self.imageView.frame toView:self.view.window.rootViewController.view];
    showPhotosVC.imageModelMutableArray = photoArr;
    showPhotosVC.startInteger = 0;
    [self.view.window.rootViewController presentViewController:showPhotosVC animated:YES completion:nil];
}

@end
