//
//  CreateVoteViewController.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "CreateComplexRequest.h"
@interface CreateComplexViewController : BaseViewController
@property (nonatomic, strong) void (^reloadComleteBlock)(void);
@property (nonatomic, assign) CreateComplexType createType;
@end
