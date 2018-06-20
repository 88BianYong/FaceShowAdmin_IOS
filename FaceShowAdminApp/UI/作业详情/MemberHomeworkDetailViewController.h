//
//  MemberHomeworkDetailViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ScrollBaseViewController.h"
@class GetUserHomeworksRequestItem_element;

@interface MemberHomeworkDetailViewController : ScrollBaseViewController
@property(nonatomic, strong) NSString *stepId;
@property(nonatomic, strong) GetUserHomeworksRequestItem_element *data;
@end
