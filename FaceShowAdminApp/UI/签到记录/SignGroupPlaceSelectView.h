//
//  SignGroupPlaceSelectView.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BMKPoiInfo;

@interface SignGroupPlaceSelectView : UIView

- (instancetype)initWithGroupName:(NSString *)groupName andPlaceString:(NSString *)placeStr;
@property (nonatomic, strong) BMKPoiInfo *selectedPoi;
@property (nonatomic, copy) NSDictionary *defaultDict;
@property (nonatomic, copy) void(^clickSelectPlaceBlock)(void);

@end

