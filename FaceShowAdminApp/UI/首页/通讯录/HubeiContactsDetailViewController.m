//
//  HubeiContactsDetailViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HubeiContactsDetailViewController.h"
#import "ErrorView.h"
#import "GetUserInfoDetailRequest.h"
#import "UserSignInPercentRequest.h"
#import "DetailCellView.h"
#import "DetailWithAttachmentCellView.h"
#import "UserSignInListViewController.h"
#import "UnsignedMemberListViewController.h"
#import "AreaManager.h"

@interface HubeiContactsDetailViewController ()
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) MASViewAttribute *lastBottom;
@property (nonatomic, strong) DetailCellView *percentCell;

@property (nonatomic, strong) GetUserInfoDetailRequest *userInfoRequest;
@property (nonatomic, strong) UserSignInPercentRequest *percentRequest;
@property (nonatomic, strong) GetUserInfoDetailRequestItem_Data *data;
@end

@implementation HubeiContactsDetailViewController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestUserInfo {
    [self.userInfoRequest stopRequest];
    self.userInfoRequest = [[GetUserInfoDetailRequest alloc] init];
    self.userInfoRequest.userId = self.userId;
    [self.view.window nyx_startLoading];
    WEAK_SELF
    [self.userInfoRequest startRequestWithRetClass:[GetUserInfoDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view.window nyx_stopLoading];
        self.errorView.hidden = YES;
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        GetUserInfoDetailRequestItem *item = (GetUserInfoDetailRequestItem *)retItem;
        self.data = item.data;
        [self setupUI];
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
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    nameLabel.text = self.data.realName;
    [headWhiteView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(avatarImageView.mas_right).offset(15);
        make.right.mas_equalTo(-15);
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
    //-联系电话-性别-学段-学科-省市区-学校-身份证号-学校所在区域-学校类别-民族-职称-最高学历-毕业院校-所学专业
    NSArray *titles = @[@"联系电话", @"性别", @"学段", @"学科", @"省", @"市", @"区", @"学校", @"身份证号", @"学校所在区域", @"学校类别", @"民族", @"职称", @"最高学历", @"毕业院校", @"所学专业"];
    Area *province = nil;
    Area *city = nil;
    Area *district = nil;
    if (!isEmpty(self.data.aui.province)) {
        for (Area *area in [AreaManager sharedInstance].areaModel.data) {
            if (self.data.aui.province.integerValue == area.areaID.integerValue) {
                province = area;
                break;
            }
        }
    }
    if (!isEmpty(self.data.aui.city)) {
        for (Area *area in province.sub) {
            if (self.data.aui.city.integerValue == area.areaID.integerValue) {
                city = area;
                break;
            }
        }
    }
    if (!isEmpty(self.data.aui.country)) {
        for (Area *area in city.sub) {
            if (self.data.aui.country.integerValue == area.areaID.integerValue) {
                district = area;
                break;
            }
        }
    }
    NSArray *contents = @[
                          self.data.mobilePhone,
                          [self.data sexString],
                          isEmpty(self.data.stageName) ? @"暂无" : self.data.stageName,
                          isEmpty(self.data.subjectName) ? @"暂无" : self.data.subjectName,
                          isEmpty(province) ? @"暂无" : province.name,
                          isEmpty(city) ? @"暂无" : city.name,
                          isEmpty(district) ? @"暂无" : district.name,
                          isEmpty(self.data.school) ? @"暂无" : self.data.school,
                          isEmpty(self.data.aui.idCard) ? @"暂无" : self.data.aui.idCard,
                          isEmpty(self.data.aui.area) ? @"暂无" : self.data.aui.area,
                          isEmpty(self.data.aui.schoolType) ? @"暂无" : self.data.aui.schoolType,
                          isEmpty(self.data.aui.nation) ? @"暂无" : self.data.aui.nation,
                          isEmpty(self.data.aui.title) ? @"暂无" : self.data.aui.title,
                          isEmpty(self.data.aui.recordeducation) ? @"暂无" : self.data.aui.recordeducation,
                          isEmpty(self.data.aui.graduation) ? @"暂无" : self.data.aui.graduation,
                          isEmpty(self.data.aui.professional) ? @"暂无" : self.data.aui.professional
                          ];
    self.lastBottom = headWhiteView.mas_bottom;
    for (int i = 0; i < titles.count; i++) {
        DetailCellView *detailCell = [[DetailCellView alloc] initWithTitle:titles[i] content:contents[i]];
        if (i == titles.count - 1) {
            detailCell.needBottomLine = NO;
        }
        [self.contentView addSubview:detailCell];
        [detailCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(self.lastBottom);
            if (i == titles.count-1 && self.isAdministrator) {
                make.bottom.mas_equalTo(-5);
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

@end
