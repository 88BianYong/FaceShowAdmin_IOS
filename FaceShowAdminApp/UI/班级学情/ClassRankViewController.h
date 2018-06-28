//
//  ClassRankViewController.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface ClassRankViewController : BaseViewController
- (instancetype)initWithClazsId:(NSString *)clazsId;
@property (nonatomic, assign) NSInteger selectedIndex;
@end
