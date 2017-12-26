//
//  AppDelegate+GetuiService.m
//  PeopleDailys
//
//  Created by 123 on 2017/11/21.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "AppDelegate+GetuiService.h"
#import "PDNewsDetailController.h"

@implementation AppDelegate (GetuiService)


-(void)initGetuiService{
    [GeTuiSdk startSdkWithAppId:GETUIAPPID appKey:GETUIAPPKEY appSecret:GETUIAPPSECRET delegate:self];
    
    [self registerRemoteNotification];
    
    [GeTuiSdk resetBadge]; //重置 标计数
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
    
}
#pragma mark - 用户通知(推送) _自定义方法

/** 注册远程通知 */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8的需要手动开启“TARGETS -> Capabilities -> Push Notifications”
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
//        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
//                                                                       UIRemoteNotificationTypeSound |
//                                                                       UIRemoteNotificationTypeBadge);
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}
#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    PD_NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    // [ GTSdk ]：向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[PDPublicTools sharedPublicTools]showMessage:@"didFailToRegisterForRemoteNotificationsWithError" duration:3];
    PD_NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",[error localizedDescription]);
}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送

/** APP已经接收到“远程”通知(推送) - (App运行在后台)  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    completionHandler(UIBackgroundFetchResultNewData);
    //test
    PD_NSLog(@"%@",userInfo);
    [self showNotificationPageWithUserInfo:userInfo];
}

#pragma mark - iOS 10中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    
    completionHandler();

}
#endif


#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [ GTSdk ]：个推SDK已注册，返回clientId
    PD_NSLog(@">>[GTSdk RegisterClient]:%@", clientId);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
//    // 数据转换
//    NSString *payloadMsg = nil;
//    if (payloadData) {
//        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
//    }
//
////    // 页面显示日志
////    NSString *record = [NSString stringWithFormat:@"%d, %@, %@%@", ++_lastPayloadIndex, [self formateTime:[NSDate date]], payloadMsg, offLine ? @"<离线消息>" : @"<非离线消息>"];
////
//    NSString *record = [NSString stringWithFormat:@"%@, %@%@", [self formateTime:[NSDate date]], payloadMsg, offLine ? @"<离线消息>" : @"<非离线消息>"];
//
//    PD_NSLog(@"%@",record);
//
//    // 控制台打印日志
//    NSString *msg = [NSString stringWithFormat:@"%@ : %@%@", [self formateTime:[NSDate date]], payloadMsg, offLine ? @"<离线消息>" : @""];
//    PD_NSLog(@">>[GTSdk ReceivePayload]:%@, taskId: %@, msgId :%@", msg, taskId, msgId);
//
//
    //test
    [self showNotificationPageWithPayloadData:payloadData andOffLine:offLine];
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 页面显示：上行消息结果反馈
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    PD_NSLog(@"%@",record);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // 页面显示：个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。

    
    PD_NSLog(@">>>[GexinSdk error]:%@",[error localizedDescription]);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // 页面显示更新通知SDK运行状态
    switch (aStatus) {
        case SdkStatusStarting:{
            PD_NSLog(@"SDK运行状态:正在启动");
        }
            break;
        case SdkStatusStarted:{
            PD_NSLog(@"SDK运行状态:启动");
        }
            break;
        case SdkStatusStoped:{
            PD_NSLog(@"SDK运行状态:停止");
        }
            break;
        default:
            break;
    }
}

/** SDK设置推送模式回调  */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    // 页面显示错误信息
    if (error) {
        PD_NSLog(@">>>[SetModeOff error]: %@",[error localizedDescription]);
        return;
    }
    PD_NSLog(@">>>[GexinSdkSetModeOff]: %@", isModeOff ? @"开启" : @"关闭");
}

#pragma mark - 其他
- (NSString *)formateTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}


/** SDK收到透传消息回调处理事件 */
-(void)showNotificationPageWithPayloadData:(NSData*)payloadData andOffLine:(BOOL)offLine{
    
    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    // 控制台打印日志
    NSString *msg = [NSString stringWithFormat:@"%@\npayloadMsg:%@\n%@", [self formateTime:[NSDate date]], payloadMsg, offLine ? @"<离线消息>" : @"<非离线消息>"];
    PD_NSLog(@">>[GTSdk ReceivePayload]:\n%@", msg);
    [[PDPublicTools sharedPublicTools]showMessage:msg duration:5];

    if (offLine) {  //离线推送
        NSDictionary *payloadDic = [NSJSONSerialization JSONObjectWithData:payloadData
                                                                   options:NSJSONReadingMutableLeaves
                                                                     error:nil];
        
        NSString *opernUrl = [payloadDic objectForKey:@"openurl"];
        if (opernUrl.length) {
            [[PDPublicTools sharedPublicTools]showMessage:opernUrl duration:5];
        }
        [[PDPublicTools sharedPublicTools]showMessage:@"离线透传推送" duration:5];

    }else{  //非离线推送
        [[PDPublicTools sharedPublicTools]showMessage:@"非离线透传推送" duration:5];
    }
}

-(void)showNotificationPageWithUserInfo:(NSDictionary*)userInfo{
    
    // 显示APNs信息到页面
    NSString *record = [NSString stringWithFormat:@"[APN]%@\n%@", [NSDate date], userInfo];
    PD_NSLog(@"%@",record);
    
    [[PDPublicTools sharedPublicTools]showMessage:record duration:5];

    
//    NSData *jsonData = [[userInfo objectForKey:@"category"] dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *payloadDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *payloadDic = [userInfo objectForKey:@"category"];

    if (payloadDic) {
        NSString *ID = payloadDic[@"txt"];
        PDNewsDetailController *detailVC = [[PDNewsDetailController alloc]init];
        detailVC.ID = ID;
        PDNavigationController *navVC =(PDNavigationController*) ((PDTabBarController*)self.window.rootViewController).selectedViewController;
        [navVC pushViewController:detailVC animated:YES];
    }
}

@end
