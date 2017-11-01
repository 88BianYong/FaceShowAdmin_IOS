//
//  NoticeDetailViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeDetailViewController.h"

@interface NoticeDetailViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation NoticeDetailViewController

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
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.view addSubview:self.scrollView];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.containerView];
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.containerView addSubview:self.topView];
    CGFloat height = 5.0;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.titleLabel.numberOfLines = 0;
    [self.containerView addSubview:self.titleLabel];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    self.titleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:self.element.title?:@"" attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    height = height + 25.0f + ceilf([self.titleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 25.0f - 25.0f , MAXFLOAT)].height);
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.text = self.element.createTime;
    [self.containerView addSubview:self.timeLabel];
    height += 15.0f + 13.0f;
    
    self.readLabel = [[UILabel alloc] init];
    self.readLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
    self.readLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    self.readLabel.textAlignment = NSTextAlignmentCenter;
    NSString *readString = [NSString stringWithFormat:@"已阅读: %@/%@",self.element.noticeReadUserNum,self.studentNum];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:readString];
    [attString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],
                               NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]} range:NSMakeRange(0, 3)];
    self.readLabel.attributedText = attString;
    [self.containerView addSubview:self.readLabel];
    height += 15.0f + 13.0f;
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.font = [UIFont systemFontOfSize:14.0];
    self.contentLabel.numberOfLines = 0;
    NSMutableParagraphStyle *cStyle = [[NSMutableParagraphStyle alloc] init];
    cStyle.lineHeightMultiple = 1.2f;
    self.contentLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:self.element.content?:@"" attributes:@{NSParagraphStyleAttributeName:cStyle}];
    [self.containerView addSubview:self.contentLabel];
    
     height += 20.0f + ceilf([self.contentLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 25.0f - 25.0f , MAXFLOAT)].height);
    WEAK_SELF
    self.imageView = [[UIImageView alloc] init];
    self.imageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    [self.containerView addSubview:self.imageView];
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
    height += 21.0f + SCREEN_WIDTH - 25.0f - 25.0f;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH , height);
    [self setupNavRightView];
}

- (void)setupNavRightView {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightBtn.frame = CGRectMake(0, 0, 75, 30);
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navRightBtn setTitle:@"更多" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor colorWithHexString:@"1da1f2"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"扫一扫icon-正常态"] forState:UIControlStateNormal];
    [navRightBtn setImage:[UIImage imageNamed:@"扫一扫icon-点击态"] forState:UIControlStateHighlighted];
    WEAK_SELF
    [[navRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        
    }];
    [self nyx_setupRightWithCustomView:navRightBtn];
}
- (void)setupLayout {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.scrollView.mas_top);
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
        make.top.equalTo(self.topView.mas_bottom).offset(25.0f);
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
        make.top.equalTo(self.readLabel.mas_bottom).offset(17.0f);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(21.0f);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.width.equalTo(self.imageView.mas_height);
    }];    
}
@end
