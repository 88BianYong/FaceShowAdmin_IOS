//
//  ResourceListCell.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceManagerRequest.h"
@interface ResourceListCell : UITableViewCell
@property (nonatomic, strong) ResourceManagerRequestItem_Data_Resources_Elements *element;
@end
