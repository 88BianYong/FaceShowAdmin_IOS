//
//  QuestionTemplatesHeaderView.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTemplatesHeaderView : UITableViewHeaderFooterView
- (void)reloadTemplate:(NSString *)title withIndex:(NSInteger)index withType:(NSInteger)type;
@end
