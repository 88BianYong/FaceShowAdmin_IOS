//
//  NoticeDetailViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "NoticeDeleteRequest.h"
#import "FDActionSheetView.h"
#import "AlertView.h"
#import "ShowPhotosViewController.h"
@interface NoticeDetailViewController ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *headerBackImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) NoticeDeleteRequest *deleteRequest;
@end

@implementation NoticeDetailViewController
- (void)dealloc {
    DDLogDebug(@"release========>>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通知详情";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - setupUI
- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_offset(5.0f);
    }];

    self.headerBackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"通知详情背景图"]];
    [self.contentView addSubview:self.headerBackImage];
    [self.headerBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(150);
    }];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    self.titleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:self.element.title?:@"" attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25.0f);
        make.right.mas_equalTo(-25.0f);
        make.top.equalTo(self.topView.mas_bottom).offset(20.0f);
    }];

    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.text = [[self.element.createTime omitSecondOfFullDateString] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(13.0f);
    }];

    self.readLabel = [[UILabel alloc] init];
    self.readLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
    self.readLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    self.readLabel.textAlignment = NSTextAlignmentCenter;
    NSString *readString = [NSString stringWithFormat:@"已阅读: %@/%@",self.element.noticeReadUserNum?:@"0",self.studentNum];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:readString];
    [attString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],
                               NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]} range:NSMakeRange(0, 3)];
    self.readLabel.attributedText = attString;
    [self.contentView addSubview:self.readLabel];
    [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(13.0f);
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0];
    self.contentLabel.numberOfLines = 0;
    NSMutableParagraphStyle *cStyle = [[NSMutableParagraphStyle alloc] init];
    cStyle.lineHeightMultiple = 1.2f;
    self.contentLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:self.element.content?:@"" attributes:@{NSParagraphStyleAttributeName:cStyle}];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.readLabel.mas_bottom).offset(15.0f);
    }];

    WEAK_SELF
    self.imageView = [[UIImageView alloc] init];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.hidden = YES;
    self.imageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    [self.contentView addSubview:self.imageView];
    if (self.element.attachUrl.length > 0) {
//        UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朋友圈一张图加载失败图片"]];
//        [self.imageView addSubview:placeholderImageView];
//        [placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.imageView);
//        }];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.element.attachUrl] placeholderImage:[UIImage imageNamed:@"朋友圈一张图加载失败图片"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            STRONG_SELF
            if (error == nil) {
                self.imageView.backgroundColor = [UIColor clearColor];
            }
            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15.0f);
                make.right.mas_equalTo(-15.0f);
                make.top.equalTo(self.contentLabel.mas_bottom).offset(21.0f);
                make.width.mas_equalTo(self.imageView.mas_height).multipliedBy(image.size.width/image.size.height);
                make.bottom.mas_equalTo(-10);
            }];

        }];
        self.imageView.hidden = NO;
    }else{
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];

    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.imageView addGestureRecognizer:tap];
    [self nyx_setupRightWithImageName:@"更多操作按钮正常态" highlightImageName:@"更多操作按钮点击态" action:^{
        STRONG_SELF
        [self showAlertView];
    }];
}

- (void)showAlertView {
    FDActionSheetView *actionSheetView = [[FDActionSheetView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    actionSheetView.titleArray = @[@{@"title":@"删除"}];
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
                make.height.mas_offset(105.0f);
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
            make.height.mas_offset(105.0f );
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
                    make.height.mas_offset(105.0f);
                }];
                [view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        });
    }];
    actionSheetView.actionSheetBlock = ^(NSInteger integer) {
        STRONG_SELF
        if (integer == 1) {
            [TalkingData trackEvent:@"删除通知"];
            [self requestForDeleteNotice];
        }
        [self.alertView hide];
    };
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    ShowPhotosViewController *showPhotosVC = [[ShowPhotosViewController alloc] init];
    PreviewPhotosModel *model = [[PreviewPhotosModel alloc] init];
    model.original = self.element.attachUrl;
    NSMutableArray *photoArr = [NSMutableArray arrayWithObject:model];
    showPhotosVC.animateRect = [self.view convertRect:self.imageView.frame toView:self.view.window.rootViewController.view];
    showPhotosVC.imageModelMutableArray = photoArr;
    showPhotosVC.startInteger = 0;
    [[self nyx_visibleViewController] presentViewController:showPhotosVC animated:YES completion:nil];
}

#pragma mark - request
- (void)requestForDeleteNotice {
    [self.deleteRequest stopRequest];
    self.deleteRequest = [[NoticeDeleteRequest alloc] init];
    self.deleteRequest.noticeId = self.element.elementId;
    self.deleteRequest.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.deleteRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error == nil) {
            BLOCK_EXEC(self.noticeDetailDeleteBlock);
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self.view nyx_showToast:error.localizedDescription];
        }
    }];
}
@end
