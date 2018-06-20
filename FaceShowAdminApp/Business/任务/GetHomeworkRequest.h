//
//  GetHomeworkRequest.h
//  FaceShowApp
//
//  Created by ZLL on 2018/6/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetHomeworkRequestItem_attachmentInfo <NSObject>
@end
@interface GetHomeworkRequestItem_attachmentInfo : JSONModel
@property (nonatomic, strong) NSString<Optional> *resId;
@property (nonatomic, strong) NSString<Optional> *resKey;
@property (nonatomic, strong) NSString<Optional> *resName;
@property (nonatomic, strong) NSString<Optional> *resType;
@property (nonatomic, strong) NSString<Optional> *ext;
@property (nonatomic, strong) NSString<Optional> *downloadUrl;
@property (nonatomic, strong) NSString<Optional> *previewUrl;
@property (nonatomic, strong) NSString<Optional> *transcodeStatus;
@property (nonatomic, strong) NSString<Optional> *resThumb;
@property (nonatomic, strong) NSString<Optional> *resSource;
@end

@interface GetHomeworkRequestItem_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *resourceKey;
@property (nonatomic, strong) NSString<Optional> *resourceSource;
@property (nonatomic, strong) NSString<Optional> *homeworkStatus;
@property (nonatomic, strong) NSString<Optional> *bizId;
@property (nonatomic, strong) NSString<Optional> *bizSource;
@property (nonatomic, strong) NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *stepId;
@property (nonatomic, strong) NSArray<GetHomeworkRequestItem_attachmentInfo, Optional> *attachmentInfos;
@property (nonatomic, strong) NSString<Optional> *totalUserNum;
@property (nonatomic, strong) NSString<Optional> *finishUserNum;
@property (nonatomic, strong) NSString<Optional> *finishPercent;
@end

@interface GetHomeworkRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetHomeworkRequestItem_data<Optional> *data;
@end

@interface GetHomeworkRequest : YXGetRequest
@property (nonatomic, strong) NSString *stepId;
@end
