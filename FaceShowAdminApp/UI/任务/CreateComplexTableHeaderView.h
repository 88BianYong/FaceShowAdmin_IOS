//
//  CreateComplexTableHeaderView.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskChooseContentView.h"
@interface CreateComplexTableHeaderView : UIView
@property (nonatomic, strong) TaskChooseContentView *templateView;
@property (nonatomic, strong) TaskChooseContentView *courseView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) SAMTextView *textView;
- (void)reloadInputNumber;
- (void)keyBoardHide;
@end
