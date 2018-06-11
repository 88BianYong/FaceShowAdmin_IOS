//
//  PublishTaskCell.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishTaskCell : UICollectionViewCell
- (void)reloadTask:(NSString *)name defaultImage:(NSString *)icon highlightImage:(NSString *)image;
@end
