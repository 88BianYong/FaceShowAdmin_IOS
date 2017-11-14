//
//  SubjectivityAnswerTitleView.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubjectivityAnswerTitleView : UIView
@property (nonatomic, strong) NSString *title;

+ (CGFloat)heightForTitle:(NSString *)title;
@end
