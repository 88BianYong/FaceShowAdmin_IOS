//
//  CustomTimeSettingView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTimeSettingView : UICollectionReusableView
@property (nonatomic, strong, readonly) NSString *startTime;
@property (nonatomic, strong, readonly) NSString *endTime;

@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@end
