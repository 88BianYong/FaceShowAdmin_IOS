//
//  SignInScopeSelectView.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SignInScopeType_Class = 1,
    SignInScopeType_Group = 2
} SignInScopeType;


NS_ASSUME_NONNULL_BEGIN

@interface SignInScopeSelectView : UIView

@property(nonatomic, assign) SignInScopeType signScopeType;
@property(nonatomic, copy) void(^ChooseSignScopeBlock)(void);
@property(nonatomic, assign) BOOL canSelect;
@end

NS_ASSUME_NONNULL_END
