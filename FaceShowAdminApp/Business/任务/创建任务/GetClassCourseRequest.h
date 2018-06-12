//
//  GetClassCourseRequest.h
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//
/**
 获取班级的课程
 */
#import "YXGetRequest.h"
@protocol GetClassCourseRequestItem_Data  @end
@interface GetClassCourseRequestItem_Data : JSONModel
@property (nonatomic, copy) NSString<Optional> *courseName;
@property (nonatomic, copy) NSString<Optional> *courseId;
@end
@interface GetClassCourseRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetClassCourseRequestItem_Data, Optional> *data;
@end
@interface GetClassCourseRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *clazsId;
@end
