//
//  UnsignedMemberListViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListViewControllerBase.h"

extern NSString * const kReplenishSignInDidSuccessNotification;

@interface UnsignedMemberListViewController : PagedListViewControllerBase
@property (nonatomic, strong) NSString *stepId;
@end
