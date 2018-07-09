//
//  HubeiDistrictSelectionViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "AreaManager.h"

UIKIT_EXTERN NSNotificationName const kAreaDidSelectNotification;
UIKIT_EXTERN NSString * const kProvinceItemKey;
UIKIT_EXTERN NSString * const kCityItemKey;
UIKIT_EXTERN NSString * const kDistrictItemKey;

@interface HubeiDistrictSelectionViewController : BaseViewController
@property (nonatomic, strong) Area *currentProvince;
@property (nonatomic, strong) Area *currentCity;
@property (nonatomic, strong) Area *currentDistrict;
@end
