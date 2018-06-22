//
//  ProjectFilterViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface ProjectFilterViewController : BaseViewController
@property (nonatomic, strong) void(^selectBlock)(NSString *provinceID,NSString *cityID,NSString *districtID,NSString *startTime,NSString *endTime);
@end
