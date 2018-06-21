//
//  GetUserPlatformRequest.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/6/21.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetUserPlatformRequestItem_platformInfos<NSObject>
@end
@interface GetUserPlatformRequestItem_platformInfos:JSONModel
@property (nonatomic, strong) NSString<Optional> *platformId;
@end

@interface GetUserPlatformRequestItem_data : JSONModel
@property (nonatomic, strong) NSArray<GetUserPlatformRequestItem_platformInfos,Optional> *platformInfos;
@end

@interface GetUserPlatformRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) GetUserPlatformRequestItem_data<Optional> *data;
@end

@interface GetUserPlatformRequest : YXGetRequest

@end
