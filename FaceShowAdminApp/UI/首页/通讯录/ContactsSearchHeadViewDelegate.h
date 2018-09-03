//
//  SearchHeadViewDelegate.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/8/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GetUserInfoRequestItem_Data;
@protocol ContactsSearchHeadViewDelegate <NSObject>
- (void)searchFieldDidBeginEditting;
- (void)searchFieldDidEndEditting;
- (void)searchFieldDidTextChange:(NSString *)searchStr;
@end
