//
//  EditQuestionTableHeaderView.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditQuestionTableHeaderView : UIView
@property (nonatomic, copy) void(^questionTypeBlock)(NSString *typeString);
- (void)reloadSelected;
@end
