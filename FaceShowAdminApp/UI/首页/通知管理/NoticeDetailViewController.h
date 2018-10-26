//
//  NoticeDetailViewController.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ScrollBaseViewController.h"
#import "NoticeListRequest.h"
@interface NoticeDetailViewController : ScrollBaseViewController
@property (nonatomic, strong) NoticeListRequestItem_Data_NoticeInfos_Elements *element;
@property (nonatomic, strong) NSString *studentNum;
@property (nonatomic, copy) void(^noticeDetailDeleteBlock)(void);
@end
