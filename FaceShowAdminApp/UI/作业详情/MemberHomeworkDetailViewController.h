//
//  MemberHomeworkDetailViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
@class GetUserHomeworksRequestItem_element;

@interface MemberHomeworkDetailViewController : BaseViewController
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *dataArray; 
@property(nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) void (^commentComleteBlock)(NSString *comment,NSInteger currentIndex);
@end
