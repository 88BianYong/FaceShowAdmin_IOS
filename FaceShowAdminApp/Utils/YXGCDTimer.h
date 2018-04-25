//
//  YXGCDTimer.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/4/25.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXGCDTimer : NSObject
- (instancetype)initWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats triggerBlock:(void(^)(void))triggerBlock;

- (void)resume;
- (void)suspend;
@end
