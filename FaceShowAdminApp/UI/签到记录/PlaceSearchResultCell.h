//
//  PlaceSearchResultCell.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/5/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapKit/BaiduMapAPI_Search/BMKSearchComponent.h>

@interface PlaceSearchResultCell : UITableViewCell
@property (nonatomic, strong) BMKPoiInfo *poiInfo;
@property (nonatomic, assign) BOOL isCurrent;
@end

