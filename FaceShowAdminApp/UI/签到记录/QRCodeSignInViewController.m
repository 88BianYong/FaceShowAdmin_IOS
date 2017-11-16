//
//  QRCodeSignInViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QRCodeSignInViewController.h"
#import "GCDTimer.h"

@interface QRCodeSignInViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) GCDTimer *timer;
@end

@implementation QRCodeSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"签到二维码";
    [self setupUI];
    [self loadImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction {
    BLOCK_EXEC(self.backBlock);
    [super backAction];
}

- (void)setupUI {
    self.imageView = [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(90*kPhoneHeightRatio);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(260*kPhoneWidthRatio, 260*kPhoneWidthRatio));
    }];
}

- (void)loadImage {
    BOOL repeat = self.data.qrcodeRefreshRate.integerValue>0;
    NSString *urlStr = [NSString stringWithFormat:@"%@?method=interact.signInQrcode&stepId=%@",[ConfigManager sharedInstance].server,self.data.stepId];
    WEAK_SELF
    self.timer = [[GCDTimer alloc]initWithInterval:self.data.qrcodeRefreshRate.floatValue repeats:repeat triggerBlock:^{
        STRONG_SELF
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:urlStr]];
        SDImageCache *cache = [SDImageCache sharedImageCache];
        WEAK_SELF
        [cache removeImageForKey:key withCompletion:^{
            STRONG_SELF
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
        }];        
    }];
    [self.timer resume];
}

@end
