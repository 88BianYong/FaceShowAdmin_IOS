//
//  GroupListRequest.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol GroupListRequest_Item_groups <NSObject> @end
@interface GroupListRequest_Item_groups : JSONModel
@property (nonatomic, strong) NSString<Optional> *studentNum;
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *leaderId;
@property (nonatomic, strong) NSString<Optional> *groupAvatar;
@property (nonatomic, strong) NSString<Optional> *avgScore;
@property (nonatomic, strong) NSString<Optional> *students;
@property (nonatomic, strong) NSString<Optional> *leader;
@property (nonatomic, strong) NSString<Optional> *groupName;
@property (nonatomic, strong) NSString<Optional> *scoreRank;
@property (nonatomic, strong) NSString<Optional> *signinRank;
@property (nonatomic, strong) NSString<Optional> *slogan;
@property (nonatomic, strong) NSString<Optional> *signinRate;
@property (nonatomic, strong) NSString<Optional> *groupsId;
@end

@interface GroupListRequest_Item_data : JSONModel
@property (nonatomic, strong) NSString<Optional> *noGroupStudentNum;
@property (nonatomic, strong) NSArray<GroupListRequest_Item_groups,Optional> *groups;
@end

@interface GroupListRequest_Item : HttpBaseRequestItem
@property (nonatomic, strong) GroupListRequest_Item_data<Optional> *data;
@end

NS_ASSUME_NONNULL_BEGIN

@interface GroupListRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@end

NS_ASSUME_NONNULL_END
