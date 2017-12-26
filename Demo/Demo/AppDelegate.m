//
//  AppDelegate.m
//  Demo
//
//  Created by 123 on 2017/12/22.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "AppDelegate.h"
#import "IMTabBarController.h"
#import "AppDelegate+WeixinService.h"
#import "AppDelegate+WeiboService.h"

@interface AppDelegate ()<WXApiDelegate,WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[IMTabBarController alloc]init];
    [self.window makeKeyAndVisible];
    
    
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setForegroundColor:[UIColor blackColor]];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    
    [self initWeixinService];
    
    [self initWeiboService];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    if ([url.absoluteString containsString:SINAAPPID]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return [WXApi handleOpenURL:url delegate:self];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([url.absoluteString containsString:SINAAPPID]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return [WXApi handleOpenURL:url delegate:self];
}

@end
