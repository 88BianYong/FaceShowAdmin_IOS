//
//  DeleteCommentRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface DeleteCommentRequest : YXGetRequest
@property (nonatomic, strong) NSString *commentRecordId;
@end
