//
//  SignInPlaceHeaderView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/5/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInPlaceHeaderViewDelegate.h"

@interface SignInPlaceHeaderView : UIView
@property (nonatomic, weak) id<SignInPlaceHeaderViewDelegate> delegate;
-(void)viewWillAppear;
-(void)viewWillDisappear;

- (void)updateWithPoiInfo:(BMKPoiInfo *)poi;
- (void)endSearching;
- (void)moveToPoi:(BMKPoiInfo *)poi;

- (void)searchNextPage;
@end
