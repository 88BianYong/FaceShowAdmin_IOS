//
//  AppDelegate.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/10/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegateHelper.h"
#import "TalkingDataConfig.h"
#import "IMManager.h"
#import "IMUserInterface.h"
#import "UserPromptsManager.h"
#import <BaiduMapKit/BaiduMapAPI_Map/BMKMapComponent.h>
#import "YXInitRequest.h"
#import "BasicDataManager.h"
#import "YXGeTuiManager.h"

@interface AppDelegate ()<BMKGeneralDelegate>
@property (nonatomic, strong) AppDelegateHelper *appDelegateHelper;
@property (nonatomic, strong) BMKMapManager *mapManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GlobalUtils setupCore];
    // Talking Data统计
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData setSignalReportEnabled:YES];
    [TalkingData sessionStarted:kTalkingDataAppKey withChannelId:kTalkingDataChannel];
    // 百度地图
    [self setupBaiduMap];
    // 初始化请求，检测版本更新等
    [[YXInitHelper sharedHelper] requestCompeletion:nil];
    // 检查基础数据更新
    [[BasicDataManager sharedInstance]checkAndUpdataBasicData];
    [[YXGeTuiManager sharedInstance] registerGeTuiWithDelegate:self];
    [self registerNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    
    if ([UserManager sharedInstance].loginStatus) {
        [[UserPromptsManager sharedInstance] resumeHeartbeat];
        [[IMManager sharedInstance]setupWithCurrentMember:[[UserManager sharedInstance].userModel.imInfo.imMember toIMMember] token:[UserManager sharedInstance].userModel.imInfo.imToken];
        [[IMManager sharedInstance]setupWithSceneID:[UserManager sharedInstance].userModel.currentClass.clazsId];
        [[IMManager sharedInstance] startConnection];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.appDelegateHelper = [[AppDelegateHelper alloc]initWithWindow:self.window];
    self.window.rootViewController = [self.appDelegateHelper rootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupBaiduMap {
    self.mapManager = [[BMKMapManager alloc]init];
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    NSString *key = nil;
#ifdef HuBeiApp
    key = @"uxIpEttWwNbVFNFF61a41nyNT2oGVT9G";
#else
    key = @"CXHRPRKoQ6Pwj0nCXet7MEhGV63KF7MY";
#endif
    BOOL ret = [_mapManager start:key generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)registerNotifications {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kUserDidLoginNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [[YXGeTuiManager sharedInstance] loginSuccess];
        [[UserPromptsManager sharedInstance] resumeHeartbeat];
        [[IMManager sharedInstance]setupWithCurrentMember:[[UserManager sharedInstance].userModel.imInfo.imMember toIMMember] token:[UserManager sharedInstance].userModel.imInfo.imToken];
        [[IMManager sharedInstance]setupWithSceneID:[UserManager sharedInstance].userModel.currentClass.clazsId];
        [[IMManager sharedInstance] startConnection];
        [self.appDelegateHelper handleLoginSuccess];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kUserDidLogoutNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [[YXGeTuiManager sharedInstance] logoutSuccess];
        [self.appDelegateHelper handleLogoutSuccess];
        [[IMManager sharedInstance] stopConnection];
        [[UserPromptsManager sharedInstance] suspendHeartbeat];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kClassDidSelectNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [UserManager sharedInstance].mainPage = MainPage_ClassDetail;
        [self.appDelegateHelper handleClassChange];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kTrainingProfileDidSelectNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [UserManager sharedInstance].mainPage = MainPage_TrainingProfile;
        [self.appDelegateHelper handleShowTrainingProfile];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kMyProjectDidSelectNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [UserManager sharedInstance].mainPage = MainPage_MyProject;
        [self.appDelegateHelper handleShowMyProject];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kProjectListDidSelectNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [UserManager sharedInstance].mainPage = MainPage_ProjectList;
        [self.appDelegateHelper handleShowProjectList];
    }];
#warning 因为后端删除班级逻辑问题,现在暂不处理删除班级,待后续重新考虑
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kIMTopicDidRemoveNotification object:nil] subscribeNext:^(id x) {
//        STRONG_SELF
//        NSNotification *noti = (NSNotification *)x;
//        IMTopic *topic = noti.object;
//        [self.appDelegateHelper handleRemoveFromOneClass:topic];
//    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if ([UserManager sharedInstance].loginStatus) {
        [[IMManager sharedInstance]stopConnection];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([UserManager sharedInstance].loginStatus) {
        [[IMManager sharedInstance]startConnection];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[IMManager sharedInstance] stopConnection];
    [GlobalUtils clearCore];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [GeTuiSdk resume]; // 后台恢复SDK 运行
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[YXGeTuiManager sharedInstance] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    DDLogError(@"%@",[NSString stringWithFormat: @"Error: %@",err]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[YXGeTuiManager sharedInstance] handleApnsContent:userInfo];
    application.applicationIconBadgeNumber -= 1;
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [self.appDelegateHelper handleOpenUrl:url];
    return YES;
}

#pragma mark - Apns Delegate
- (void)handleApnsData:(YXApnsContentModel *)apns {
    [self.appDelegateHelper handleApnsData:apns];
}

- (void)handleApnsDataOnForeground:(YXApnsContentModel *)apns {
    [self.appDelegateHelper handleApnsDataOnForeground:apns];
}


#pragma mark - BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"联网成功");
    } else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        NSLog(@"授权成功");
    } else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end
