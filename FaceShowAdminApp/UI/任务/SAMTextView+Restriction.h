//
//  SAMTextView+Restriction.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SAMTextView.h"

@interface SAMTextView (Restriction)
@property (nonatomic, assign) NSInteger characterInteger;
@property(nonatomic,copy) NSString *oldString;           //设置setter/getter方法的属性

@end
