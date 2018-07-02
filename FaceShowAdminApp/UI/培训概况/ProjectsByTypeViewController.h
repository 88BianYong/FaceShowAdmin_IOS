//
//  ProjectsByTypeViewController.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/8/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PagedListViewControllerBase.h"
@interface ProjectsByTypeViewController : PagedListViewControllerBase
@property (nonatomic, strong) NSString *projectQueryType;//1：按项目级别查询 2：按项目类型查询 3：按项目地区查询
@property (nonatomic, strong) NSString *projectQueryTypeValue;//对应级别

//projectQueryType =3 ，将provinceId、cityId、districtId 设置对应要要查询的区域范围值即可
@property (nonatomic, strong) NSString *provinceId;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *districtId;

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;

@end
