//
//  HomeworkCommentView.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeworkCommentView : UIView
@property (nonatomic, strong) void(^confirmBlock)(NSString *comment);
@end
