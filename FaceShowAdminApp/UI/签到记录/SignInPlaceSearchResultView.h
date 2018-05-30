//
//  SignInPlaceSearchResultView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/5/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceSearchResultCell.h"

@interface SignInPlaceSearchResultView : UIView
@property (nonatomic, strong) void(^selectBlock) (BMKPoiInfo *info);
@property (nonatomic, strong) void(^searchMoreBlock) (void);
- (void)updateWithResults:(NSArray<BMKPoiInfo *> *)results withKey:(NSString *)key;
- (void)updateWithNextPageResults:(NSArray<BMKPoiInfo *> *)results;
- (void)updateWithBottomHeight:(CGFloat)height;
@end
