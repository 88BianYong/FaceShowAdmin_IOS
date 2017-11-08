//
//  DetailWithAttachmentCellView.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailWithAttachmentCellView : UIView
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL needBottomLine;
@property (nonatomic, copy) void (^clickBlock)(void);
@end
