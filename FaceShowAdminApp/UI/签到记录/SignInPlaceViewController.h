//
//  SignInPlaceViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/5/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapKit/BaiduMapAPI_Search/BMKSearchComponent.h>

@interface SignInPlaceViewController : BaseViewController
@property (nonatomic, strong) BMKPoiInfo *nearbyPoi;
@property (nonatomic, strong) void(^selectBlock)(BMKPoiInfo *info);
@end
