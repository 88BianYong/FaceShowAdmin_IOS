//
//  HomeworkDetailHeaderView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetHomeworkRequestItem_data;

@interface HomeworkDetailHeaderView : UIView
@property (nonatomic, strong) void(^clickBlock) (void);
@property(nonatomic, strong) GetHomeworkRequestItem_data *data;
@end
