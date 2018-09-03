//
//  ContactsDetailViewController.m
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ContactsDetailViewController.h"
#import "ErrorView.h"
#import "GetUserInfoRequest.h"
#import "UserSignInPercentRequest.h"
#import "GetMemberIdRequest.h"
#import "DetailCellView.h"
#import "DetailWithAttachmentCellView.h"
#import "UserSignInListViewController.h"
#import "UnsignedMemberListViewController.h"
#import "ChatViewController.h"

@interface ContactsDetailViewController ()
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) MASViewAttribute *lastBottom;
@property (nonatomic, strong) DetailCellView *percentCell;

@property (nonatomic, strong) GetUserInfoRequest *userInfoRequest;
@property (nonatomic, strong) UserSignInPercentRequest *percentRequest;
@property (nonatomic, strong) GetUserInfoRequestItem_Data *data;
@property (nonatomic, strong) GetMemberIdRequest *memberIdRequest;
@property (nonatomic, strong) GetMemberIdRequestItem_data *memberData;
@end

@implementation ContactsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资料详情";
    
    self.errorView = [[ErrorView alloc] init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestUserInfo];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;

    [self requestUserInfo];

    [self requestMemberId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestUserInfo {
    [self.userInfoRequest stopRequest];
    self.userInfoRequest = [[GetUserInfoRequest alloc] init];
    self.userInfoRequest.method = @"sysUser.userInfo";
    self.userInfoRequest.userId = self.userId;
    [self.view.window nyx_startLoading];
    WEAK_SELF
    [self.userInfoRequest startRequestWithRetClass:[GetUserInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view.window nyx_stopLoading];
        self.errorView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        GetUserInfoRequestItem *item = (GetUserInfoRequestItem *)retItem;
        self.data = item.data;
        [self setupUI];
    }];
}

- (void)requestMemberId {
    self.memberIdRequest = [[GetMemberIdRequest alloc]init];
    self.memberIdRequest.bizSource = @"1";
    self.memberIdRequest.userId = self.userId;
    [self.memberIdRequest startRequestWithRetClass:[GetMemberIdRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        GetMemberIdRequestItem *item = (GetMemberIdRequestItem *)retItem;
        self.memberData = item.data;
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    UIView *headWhiteView = [[UIView alloc] init];
    headWhiteView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:headWhiteView];
    [headWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(76);
    }];
    
    UIImageView *avatarImageView = [[UIImageView alloc] init];
    avatarImageView.clipsToBounds = YES;
    avatarImageView.layer.cornerRadius = 6;
    avatarImageView.backgroundColor = [UIColor colorWithHexString:@"dadde0"];
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.data.avatar] placeholderImage:[UIImage imageNamed:@"班级圈大默认头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        avatarImageView.contentMode = isEmpty(image) ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
    }];
    [headWhiteView addSubview:avatarImageView];
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];

    UIButton *sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendMessageButton setImage:[UIImage imageNamed:@"对话"] forState:0];
    [sendMessageButton addTarget:self action:@selector(clickSendMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [headWhiteView addSubview:sendMessageButton];
    [sendMessageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.mas_equalTo(0);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.text = self.data.realName;
    [headWhiteView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(avatarImageView.mas_right).offset(15);
        make.right.mas_equalTo(sendMessageButton.mas_left).offset(-15);
        make.centerY.mas_equalTo(0);
    }];


    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [headWhiteView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    NSArray *titles = @[@"联系电话", @"性别", @"学段", @"学科", @"学校"];
    NSArray *contents = @[
                          self.data.mobilePhone,
                          [self.data sexString],
                          isEmpty(self.data.stageName) ? @"暂无" : self.data.stageName,
                          isEmpty(self.data.subjectName) ? @"暂无" : self.data.subjectName,
                          isEmpty(self.data.school) ? @"暂无" : self.data.school
                          ];
    self.lastBottom = headWhiteView.mas_bottom;
    for (int i = 0; i < titles.count; i++) {
        DetailCellView *detailCell = [[DetailCellView alloc] initWithTitle:titles[i] content:contents[i]];
        WEAK_SELF
        detailCell.clickContentBlock = ^(NSString *content){
            STRONG_SELF
            if (i) {
                return;
            }
            NSString *urlStr=[[NSString alloc] initWithFormat:@"tel:%@",content];
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:urlStr];
            if (@available(iOS 10.0, *)) {
                [application openURL:URL options:@{} completionHandler:^(BOOL success) {

                }];
            } else {
                // Fallback on earlier versions
                [application openURL:URL];
            }
        };
        if (i == titles.count - 1) {
            detailCell.needBottomLine = NO;
        }
        [self.contentView addSubview:detailCell];
        [detailCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(self.lastBottom);
            if (self.isAdministrator && i == titles.count - 1){
                make.bottom.mas_equalTo(0);
            }
        }];
        self.lastBottom = detailCell.mas_bottom;
    }
    if (!self.isAdministrator) {
        [self setupSignInPercent];
        [self setupObserver];
        [self requestSignInPercent];
    }
}

- (void)setupSignInPercent {
    self.percentCell = [[DetailCellView alloc] initWithTitle:@"签到率" content:@""];
    self.percentCell.contentLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
    [self.contentView addSubview:self.percentCell];
    [self.percentCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lastBottom).offset(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];
    
    DetailWithAttachmentCellView *recordCell = [[DetailWithAttachmentCellView alloc] init];
    recordCell.title = @"签到记录";
    recordCell.needBottomLine = NO;
    WEAK_SELF
    recordCell.clickBlock = ^{
        STRONG_SELF
        [TalkingData trackEvent:@"查看学员签到记录"];
        UserSignInListViewController *vc = [[UserSignInListViewController alloc] init];
        vc.userId = self.userId;
        vc.userName = self.data.realName;
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self.contentView addSubview:recordCell];
    [recordCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.percentCell.mas_bottom);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kReplenishSignInDidSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self requestSignInPercent];
    }];
}

- (void)requestSignInPercent {
    [self.percentRequest stopRequest];
    self.percentRequest = [[UserSignInPercentRequest alloc] init];
    self.percentRequest.userId = self.userId;
    [self.view.window nyx_startLoading];
    WEAK_SELF
    [self.percentRequest startRequestWithRetClass:[UserSignInPercentRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view.window nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        UserSignInPercentRequestItem *item = (UserSignInPercentRequestItem *)retItem;
        self.percentCell.contentLabel.text = [NSString stringWithFormat:@"%.f%%", roundf(item.data.userSigninNum.floatValue/item.data.totalSigninNum.floatValue*100)];
    }];
}

-(void)clickSendMessageAction{
    [self.view nyx_showToast:@"开启私聊..."];
    if (self.data) {

    }
}

@end
