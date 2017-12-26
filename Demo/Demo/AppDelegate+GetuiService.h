//
//  AppDelegate+GetuiService.h
//  PeopleDailys
//
//  Created by 123 on 2017/11/21.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "AppDelegate.h"


// iOS10 及以上需导  UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
/// 使 个推回调时，需要添加"GeTuiSdkDelegate"
/// iOS 10 及以上环境，需要添加 UNUserNotificationCenterDelegate 协议，才能使  UserNoti fications.framework 的回调

@interface AppDelegate (GetuiService)<GeTuiSdkDelegate, UNUserNotificationCenterDelegate>



-(void)initGetuiService;

@end
