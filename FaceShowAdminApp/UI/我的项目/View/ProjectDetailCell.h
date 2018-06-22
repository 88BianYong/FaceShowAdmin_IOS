//
//  ProjectDetailCell.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetMyProjectsRequest.h"

typedef NS_ENUM(NSUInteger, ProjectGroupType) {
    ProjectGroup_InProgress,
    ProjectGroup_Complete,
    ProjectGroup_NotStarted
};

@interface ProjectDetailCell : UITableViewCell
@property (nonatomic, assign) ProjectGroupType type;
@property (nonatomic, strong) GetMyProjectsRequestItem_project *data;
@end
