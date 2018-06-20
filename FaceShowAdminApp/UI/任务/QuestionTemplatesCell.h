//
//  QuestionTemplatesCell.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTemplatesCell : UITableViewCell
- (void)reloadTemplate:(NSString *)title withType:(NSInteger)type;
@end
