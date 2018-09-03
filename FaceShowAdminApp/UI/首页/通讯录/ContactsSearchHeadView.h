//
//  SearchHeadView.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/8/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsSearchHeadViewDelegate.h"

@interface ContactsSearchHeadView : UIView
@property (nonatomic, weak) id<ContactsSearchHeadViewDelegate> delegate;

- (void)endSearching;
@end
