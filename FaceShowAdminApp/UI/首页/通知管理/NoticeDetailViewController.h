//
//  NoticeDetailViewController.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "NoticeListRequest.h"
@interface NoticeDetailViewController : BaseViewController
@property (nonatomic, strong) NoticeListRequestItem_Data_NoticeInfos_Elements *element;
@property (nonatomic, strong) NSString *studentNum;
@end
