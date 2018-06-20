//
//  EditQuestionCell.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditQuestionCell : UITableViewCell
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, copy) void(^deleteQuestionBlock)(void);
@end
