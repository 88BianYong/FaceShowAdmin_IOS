//
//  YXResourceDisplayViewController.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/8/31.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface YXResourceDisplayViewController : BaseViewController
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL needDownload;
@property (nonatomic, assign) BOOL naviBarHidden;

@property (nonatomic, strong) UIImage *backNormalImage;
@property (nonatomic, strong) UIImage *backHighlightImage;
@end
