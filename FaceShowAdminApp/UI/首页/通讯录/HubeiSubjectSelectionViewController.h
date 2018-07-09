//
//  HubeiSubjectSelectionViewController.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "StageSubjectManager.h"

UIKIT_EXTERN NSNotificationName const kStageSubjectDidSelectNotification;
UIKIT_EXTERN NSString * const kStageItemKey;
UIKIT_EXTERN NSString * const kSubjectItemKey;

@interface HubeiSubjectSelectionViewController : BaseViewController
@property (nonatomic, strong) Stage *currentStage;
@property (nonatomic, strong) Subject *currentSubject;
@end
