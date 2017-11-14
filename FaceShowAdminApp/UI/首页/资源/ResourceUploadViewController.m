//
//  ResourceUploadViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceUploadViewController.h"
#import <SAMTextView.h>
#import "ResourceUploadRequest.h"
#import "ResourceCreateRequest.h"
@interface ResourceUploadViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, strong) ResourceUploadRequest *uploadRequest;
@property (nonatomic, strong) ResourceCreateRequest *createRequest;



@end

@implementation ResourceUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"上传资源";
    [self setupUI];
    [self setupLayout];
    [self addNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];

    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.containerView];
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.containerView addSubview:self.topView];
    
    self.textField = [[UITextField alloc] init];
    self.textField.textColor = [UIColor colorWithHexString:@"333333"];
    self.textField.font = [UIFont boldSystemFontOfSize:16.0f];
    self.textField.placeholder = @"请输入资源名称 (最多20字)";
   [self.textField setValue:[UIFont boldSystemFontOfSize:16.0f] forKeyPath:@"_placeholderLabel.font"];
    
    [self.containerView addSubview:self.textField];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.containerView addSubview:self.lineView];
    
    self.textView = [[SAMTextView alloc] init];
    self.textView.font = [UIFont boldSystemFontOfSize:16.0f];
    self.textView.placeholder = @"网页链接";
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]};
    self.textView.typingAttributes = dic;
    [self.containerView addSubview:self.textView];
    WEAK_SELF
    [self nyx_setupLeftWithImageName:@"返回页面按钮正常态" highlightImageName:@"返回页面按钮点击态" action:^{
        STRONG_SELF
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    [self setupNavRightView];
}
- (void)setupLayout {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.scrollView.mas_top);
        make.height.mas_offset(SCREEN_HEIGHT);
    }];

    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.containerView.mas_top);
        make.height.mas_offset(5.0f);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f);
        make.top.equalTo(self.topView.mas_bottom).offset(21.0f);
        make.height.mas_offset(20.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f);
        make.height.mas_offset(1.0f);
        make.top.equalTo(self.textField.mas_bottom).offset(21.0f);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(15.0f);
        make.right.equalTo(self.containerView.mas_right).offset(-15.0f);
        make.top.equalTo(self.lineView.mas_bottom).offset(7.0f);
        make.height.mas_offset(100.0f);
    }];
}
- (void)addNotification {
    @weakify(self);
    RACSignal *titleSignal =
    [self.textField.rac_textSignal
     map:^id(NSString *text) {
         @strongify(self);
         return @([self isTitleLength:text]);
     }];
    RACSignal *contentSignal =
    [self.textView.rac_textSignal
     map:^id(NSString *text) {
         @strongify(self);
         return @([self isContentLength:text]);
     }];
    
    RACSignal *activeSignal =
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
    return contentString.length > 0  ? YES : NO;
}
- (BOOL)isContentLength:(NSString *)contentString {
    return contentString.length > 0  ? YES : NO;
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
         [self requestForResourceCreate];
    }];
    [self nyx_setupRightWithCustomView:self.navRightBtn];
}
#pragma mark - request
- (void)requestForResourceCreate {
    if ([self.textView.text hasPrefix:@"http://"] || [self.textView.text hasPrefix:@"https://"]) {
        self.createRequest = [[ResourceCreateRequest alloc] init];
        self.createRequest.filename = @"外部链接类型";
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        self.createRequest.createtime = [NSString stringWithFormat:@"%d",(int)interval/1000];
        self.createRequest.reserve  = [NSString stringWithFormat:@"{\"typeId\":1000,\"title\":\"%@\",\"username\":\"%@\",\"externalUrl\":\"%@\",\"uid\":\"%@\",\"shareType\":0,\"from\":6,\"source\":\"ios\",\"description\":\"\"}",self.createRequest.filename,[UserManager sharedInstance].userModel.passport?:@"",self.textView.text,
                                       [UserManager sharedInstance].userModel.userID
                                       ];
        [self.view nyx_startLoading];
        WEAK_SELF
        [self.createRequest startRequestWithRetClass:[ResourceCreateRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            if (error) {
                [self.view nyx_showToast:error.localizedDescription];
                [self.view nyx_stopLoading];
            }else {
                ResourceCreateRequestItem *item = retItem;
                if (item.resid.length > 0) {
                    [self requestForResource:item.resid];
                }else {
                    [self.view nyx_showToast:item.desc];
                }
            }
        }];
    }else {
        [self.view nyx_showToast:@"链接地址不正确"];
    }
}

- (void)requestForResource:(NSString *)resId{
    if (self.textField.text.length > 20) {
        [self.view nyx_showToast:@"通知标题最多20字"];
        return;
    }
    self.uploadRequest = [[ResourceUploadRequest alloc] init];
    self.uploadRequest.resName = self.textField.text;
    self.uploadRequest.resType = @"1";
    self.uploadRequest.resId = resId;
    self.uploadRequest.url = self.textView.text;
    self.uploadRequest.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    WEAK_SELF
    [self.uploadRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
        }else {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }];
}
@end
