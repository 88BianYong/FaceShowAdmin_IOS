//
//  GetTaskCommentTitleRequest.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetTaskCommentTitleRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *desc;
@end

@interface GetTaskCommentTitleRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetTaskCommentTitleRequestItem_data<Optional> *data;
@end

@interface GetTaskCommentTitleRequest : YXGetRequest
@property (nonatomic, strong) NSString *stepId;
@end
