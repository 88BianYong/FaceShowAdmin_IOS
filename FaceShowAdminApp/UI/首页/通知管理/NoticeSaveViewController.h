//
//  NoticeSaveViewController.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "NoticeSaveRequest.h"

@interface NoticeSaveViewController : BaseViewController
@property (nonatomic, copy) void(^noticeSaveBlock)(NoticeListRequestItem_Data_NoticeInfos_Elements *element);
@end
