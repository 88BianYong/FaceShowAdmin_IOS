//
//  FilterItemCell.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterItemCell : UICollectionViewCell
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isCurrent;
@property (nonatomic, strong) void(^clickBlock)(FilterItemCell *item);
@end
