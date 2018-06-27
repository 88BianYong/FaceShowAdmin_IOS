//
//  UserManager.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

extern NSString * const kUserDidLoginNotification;
extern NSString * const kUserDidLogoutNotification;

typedef NS_ENUM(NSUInteger, MainPageType) {
    MainPage_TrainingProfile,
    MainPage_MyProject,
    MainPage_ClassDetail,
    MainPage_Undefined
};

@interface UserManager : NSObject

+ (UserManager *)sharedInstance;

@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, assign) BOOL loginStatus;
@property (nonatomic, assign) MainPageType mainPage;
- (void)saveData ;

@end
