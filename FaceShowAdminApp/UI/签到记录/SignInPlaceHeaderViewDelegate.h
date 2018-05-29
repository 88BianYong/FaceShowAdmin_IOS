//
//  SignInPlaceHeaderViewDelegate.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/5/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapKit/BaiduMapAPI_Search/BMKSearchComponent.h>

@protocol SignInPlaceHeaderViewDelegate <NSObject>
- (void)searchFieldDidBeginEditting;
- (void)searchFieldDidEndEditting;
- (void)nearbySearchUpdated:(NSArray<BMKPoiInfo *> *)results;
- (void)searchResultUpdated:(NSArray<BMKPoiInfo *> *)results withKey:(NSString *)key;
@end
