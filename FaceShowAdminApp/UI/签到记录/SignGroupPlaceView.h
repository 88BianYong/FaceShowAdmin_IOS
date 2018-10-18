//
//  SignGroupPlaceView.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupListRequest.h"
@class BMKPoiInfo;

@interface SignGroupPlaceView : UIView

@property (nonatomic, copy) void(^changePlaceBlock)(NSInteger index);
- (void)setGroupsArray:(NSArray <GroupListRequest_Item_groups *>*)groupArray;
- (void)setBMKInfo:(BMKPoiInfo *)bmkInfo atIndex:(NSInteger)index;
- (void)setDefaultDict:(NSDictionary *)dict atIndex:(NSInteger)index;
@property (nonatomic, readonly ,assign) BOOL buttonEnabled;
- (NSString *)signInExts;
@end

