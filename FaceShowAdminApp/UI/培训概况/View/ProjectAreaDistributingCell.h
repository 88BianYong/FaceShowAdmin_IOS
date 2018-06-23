//
//  ProjectAreaDistributingCell.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetSummaryRequest.h"

@interface ProjectAreaDistributingCell : UITableViewCell
@property (nonatomic, strong) NSArray<GetSummaryRequestItem_projectStatisticInfo *> *dataArray;
@property (nonatomic, strong) NSString *groupByType;
@end
