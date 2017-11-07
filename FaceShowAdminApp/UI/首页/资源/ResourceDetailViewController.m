//
//  ResourceDetailViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ResourceDetailViewController.h"
@interface ResourceDetailViewController ()<UIWebViewDelegate>
@end
@implementation ResourceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = self.name;
    [self setupUI];
}

- (void)setupUI {
    UIWebView *webview = [[UIWebView alloc]init];
    webview.scalesPageToFit = YES;
    webview.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString]];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.view nyx_startLoading];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view nyx_stopLoading];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view nyx_stopLoading];
    [self.view nyx_showToast:@"资源加载失败"];
}

@end
