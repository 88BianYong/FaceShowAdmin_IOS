//
//  QuestionTabContainerView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTabContainerView : UIView
@property (nonatomic, strong) NSArray *tabNameArray;
@property (nonatomic, strong) void (^tabClickBlock)(NSInteger index);
@end
