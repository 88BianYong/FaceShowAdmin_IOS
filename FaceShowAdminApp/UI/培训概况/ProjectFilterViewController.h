//
//  ProjectFilterViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "AreaManager.h"

@interface ProjectFilterViewController : BaseViewController
@property (nonatomic, strong) void(^selectBlock)(Area *province,Area *city,Area *district,NSInteger timeIndex,NSString *startTime,NSString *endTime);
@property (nonatomic, strong) NSArray *chooseArray;
@end
