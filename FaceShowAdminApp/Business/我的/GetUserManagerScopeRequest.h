//
//  GetUserManagerScopeRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetUserManagerScopeRequestItem_data: JSONModel
@property (nonatomic, strong) NSArray<Optional> *provinceIdScope;
@property (nonatomic, strong) NSArray<Optional> *districtIdScope;
@property (nonatomic, strong) NSArray<Optional> *cityIdScope;
@end

@interface GetUserManagerScopeRequestItem: HttpBaseRequestItem
@property (nonatomic, strong) GetUserManagerScopeRequestItem_data<Optional> *data;
@end

@interface GetUserManagerScopeRequest : YXGetRequest
@property (nonatomic, strong) NSString *platId;
@end
