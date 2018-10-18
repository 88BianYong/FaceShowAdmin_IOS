//
//  BatchCreateSignInsRequest.h
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

//http://wiki.yanxiu.com/pages/viewpage.action?pageId=12322974#id-服务-互动工具接口-3.2修改签到
#import "YXPostRequest.h"

NS_ASSUME_NONNULL_BEGIN


@interface BatchCreateSignInsRequest : YXPostRequest
@property (nonatomic, strong) NSString<Optional> *courseId;//课程id, 与clazsId二选一
@property (nonatomic, strong) NSString<Optional> *clazsId;//班级id, 与courseId二选一
@property (nonatomic, strong) NSString<Optional> *signInTimeSetting;
@property (nonatomic, strong) NSString<Optional> *signinType; // 签到类型：1-二维码签到 2-位置签到
@property (nonatomic, strong) NSString<Optional> *antiCheat;
@property (nonatomic, strong) NSString<Optional> *qrcodeRefreshRate;
@property (nonatomic, strong) NSString<Optional> *signinPosition;
@property (nonatomic, strong) NSString<Optional> *positionSite;
@property (nonatomic, strong) NSString<Optional> *successPrompt;
@property (nonatomic, strong) NSString<Optional> *signinExts;
@end

NS_ASSUME_NONNULL_END
