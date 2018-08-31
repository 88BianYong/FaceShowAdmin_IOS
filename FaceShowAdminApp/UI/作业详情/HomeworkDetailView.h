//
//  HomeworkDetailView.h
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/8/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "QASlideItemBaseView.h"
@class GetHomeworkRequestItem_attachmentInfo;
@class GetUserHomeworksRequestItem_element;

@interface HomeworkDetailView : QASlideItemBaseView
@property(nonatomic, strong) GetUserHomeworksRequestItem_element *data;
@property(nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) void (^commentComleteBlock)(NSString *comment);
@property (nonatomic, strong) void(^previewAction)(GetHomeworkRequestItem_attachmentInfo *attachment);
- (void)reviewUserHomeworkWithComment:(NSString *)comment;
@end
