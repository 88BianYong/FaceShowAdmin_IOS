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
@interface NoticeDetailViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *headerBackImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, assign) CGFloat contentHeight;



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
    [self setupLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - setupUI
- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
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
    self.contentHeight = 5.0;
    
    self.headerBackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"通知详情背景图"]];
    [self.containerView addSubview:self.headerBackImage];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.titleLabel.numberOfLines = 0;
    [self.containerView addSubview:self.titleLabel];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    self.titleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:self.element.title?:@"" attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    self.contentHeight = self.contentHeight + 20.0f + ceilf([self.titleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 25.0f - 25.0f , MAXFLOAT)].height);
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.text = self.element.createTime;
    [self.containerView addSubview:self.timeLabel];
    self.contentHeight += 15.0f + 13.0f;
    
    self.readLabel = [[UILabel alloc] init];
    self.readLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
    self.readLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    self.readLabel.textAlignment = NSTextAlignmentCenter;
    NSString *readString = [NSString stringWithFormat:@"已阅读: %@/%@",self.element.noticeReadUserNum?:@"0",self.studentNum];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:readString];
    [attString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],
                               NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]} range:NSMakeRange(0, 3)];
    self.readLabel.attributedText = attString;
    [self.containerView addSubview:self.readLabel];
    self.contentHeight += 15.0f + 13.0f;
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0];
    self.contentLabel.numberOfLines = 0;
    NSMutableParagraphStyle *cStyle = [[NSMutableParagraphStyle alloc] init];
    cStyle.lineHeightMultiple = 1.2f;
    self.contentLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:self.element.content?:@"" attributes:@{NSParagraphStyleAttributeName:cStyle}];
    [self.containerView addSubview:self.contentLabel];
    
    self.contentHeight += 18.0f + ceilf([self.contentLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 25.0f - 25.0f , MAXFLOAT)].height);
    
    WEAK_SELF
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.hidden = YES;
    self.imageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    [self.containerView addSubview:self.imageView];
    if (self.element.attachUrl.length > 0) {
        UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朋友圈一张图加载失败图片"]];
        [self.imageView addSubview:placeholderImageView];
        [placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imageView);
        }];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.element.attachUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            STRONG_SELF
            if (error == nil) {
                [placeholderImageView removeFromSuperview];
                self.imageView.backgroundColor = [UIColor clearColor];
            }
        }];
        self.contentHeight += 21.0f + SCREEN_WIDTH - 25.0f - 25.0f + 55.0f;
        self.imageView.hidden = NO;
    }

    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH , self.contentHeight);
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
                    make.bottom.equalTo(view.mas_bottom);
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

- (void)setupLayout {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.scrollView.mas_top);
        make.height.mas_offset(self.contentHeight);
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
        make.height.mas_equalTo(150);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(13.0f);
    }];
    
    [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(13.0f);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f);
        make.top.equalTo(self.readLabel.mas_bottom).offset(15.0f);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(21.0f);
        if (self.element.attachUrl.length > 0) {
            make.width.equalTo(self.imageView.mas_height);
        }else {
            make.height.mas_offset(1.0f);
        }
    }];
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
