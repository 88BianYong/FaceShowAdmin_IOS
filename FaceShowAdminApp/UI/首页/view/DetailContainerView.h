//
//  DetailContainerView.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/10/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailContainerView : UIView
@property (nonatomic, strong) NSArray *tabItemArray;
@property (nonatomic, strong) NSArray<__kindof UIView*> *contentViews;
@end
