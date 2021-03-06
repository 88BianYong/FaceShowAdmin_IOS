//
//  TrainingProjectCell.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingProjectCell : UITableViewCell
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL lineHidden;
- (void)reloadTraining:(NSString *)name percent:(NSString *)percent level:(NSInteger)level;
@end
