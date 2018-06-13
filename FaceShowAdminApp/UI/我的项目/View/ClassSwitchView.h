//
//  ClassSwitchView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassSwitchView : UIView
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) void(^preBlock)(void);
@property (nonatomic, strong) void(^nextBlock)(void);

- (void)resetPreNext;
- (void)reachFirst;
- (void)reachLast;
@end
