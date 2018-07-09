//
//  HubeiProvinceSelectionViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "AreaManager.h"

@interface HubeiProvinceSelectionViewController : BaseViewController
@property (nonatomic, strong) Area *currentProvince;
@property (nonatomic, strong) Area *currentCity;
@property (nonatomic, strong) Area *currentDistrict;
@end
