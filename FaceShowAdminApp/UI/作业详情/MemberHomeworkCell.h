//
//  MemberHomeworkCell.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetUserHomeworksRequestItem_element;

@interface MemberHomeworkCell : UITableViewCell
@property(nonatomic, strong) NSString *isFinished;
@property(nonatomic, strong) GetUserHomeworksRequestItem_element *element;
@end
