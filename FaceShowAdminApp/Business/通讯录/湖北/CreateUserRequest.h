//
//  CreateUserRequest.h
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/7/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

//http://wiki.yanxiu.com/pages/viewpage.action?pageId=12323096#id-用户相关异步接口-3获取用户信息

@interface CreateUserRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *clazsId;
@property (nonatomic, strong) NSString<Optional> *realName;
@property (nonatomic, strong) NSString<Optional> *mobilePhone;
@property (nonatomic, strong) NSString<Optional> *sex;
@property (nonatomic, strong) NSString<Optional> *subject;
@property (nonatomic, strong) NSString<Optional> *stage;
@property (nonatomic, strong) NSString<Optional> *school;
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *idCard;
@property (nonatomic, strong) NSString<Optional> *province;
@property (nonatomic, strong) NSString<Optional> *city;
@property (nonatomic, strong) NSString<Optional> *country;
@property (nonatomic, strong) NSString<Optional> *area;
@property (nonatomic, strong) NSString<Optional> *schoolType;
@property (nonatomic, strong) NSString<Optional> *nation;
@property (nonatomic, strong) NSString<Optional> *recordeducation;
@property (nonatomic, strong) NSString<Optional> *graduation;
@property (nonatomic, strong) NSString<Optional> *professional;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *childProjectId;
@property (nonatomic, strong) NSString<Optional> *childProjectName;
@property (nonatomic, strong) NSString<Optional> *organizer;
@property (nonatomic, strong) NSString<Optional> *telephone;
@property (nonatomic, strong) NSString<Optional> *job;
@property (nonatomic, strong) NSString<Optional> *email;
@end
