//
//  SignInTypeView.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/5/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChooseSignTypeBlock)(void);

@interface SignInTypeView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isSelected;

- (void)setChooseSignTypeBlock:(ChooseSignTypeBlock)block;
@end
