//
//  ContactsSearchResultView.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/8/31.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsListCell.h"
#import "GetUserInfoRequest.h"
@interface ContactsSearchResultView : UIView
@property (nonatomic, strong) void(^selectBlock) (NSIndexPath *indexPath,GetUserInfoRequestItem_Data *data);

- (void)searchWithString:(NSString *)searchText;
- (void)updateWithBottomHeight:(CGFloat)height;
@end
