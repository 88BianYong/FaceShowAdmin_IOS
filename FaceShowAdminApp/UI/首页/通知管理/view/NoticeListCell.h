//
//  NoticeListCell.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeListRequest.h"
@interface NoticeListCell : UITableViewCell
- (void)reloadCell:(NoticeListRequestItem_Data_NoticeInfos_Elements *)element withStudentNum:(NSString *)number;
@end
