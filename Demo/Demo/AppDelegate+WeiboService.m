//
//  AppDelegate+WeiboService.m
//  PeopleDailys
//
//  Created by 123 on 2017/11/13.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "AppDelegate+WeiboService.h"

@implementation AppDelegate (WeiboService)

-(void)initWeiboService{
    [WeiboSDK enableDebugMode:NO];
    [WeiboSDK registerApp:SINAAPPID];
}



//微博接收响应
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]){
        [SVProgressHUD dismiss];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
//        PD_NSLog(@"\n响应状态:%ld\n响应UserInfo数据%@\n原请求UserInfo数据%@\nauthResponse%@",(long)response.statusCode,response.userInfo,response.requestUserInfo,sendMessageToWeiboResponse.authResponse);
        switch (response.statusCode) {
            case WeiboSDKResponseStatusCodeSuccess:{
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:[sendMessageToWeiboResponse.authResponse accessToken] forKey:PD_ACCESSTOKEN];
                [userDefault setObject:[sendMessageToWeiboResponse.authResponse userID] forKey:PD_USERID];
                [userDefault setObject:[sendMessageToWeiboResponse.authResponse refreshToken] forKey:PD_REFRESHTOKEN];
                [userDefault synchronize];
            }
                break;
            case WeiboSDKResponseStatusCodeUserCancel:{
                [[PDPublicTools sharedPublicTools]showMessage:@"用户取消登录" duration:3];
            }
                break;
            case WeiboSDKResponseStatusCodeUserCancelInstall:{
                [[PDPublicTools sharedPublicTools]showMessage:@"用户取消安装" duration:3];
            }
                break;
            case WeiboSDKResponseStatusCodeShareInSDKFailed:{
                [[PDPublicTools sharedPublicTools]showMessage:@"分享失败" duration:3];
            }
                break;
            default:
                break;
        }
        
        [[PDPublicTools sharedPublicTools]showMessage:[response.userInfo objectForKey:@"msg"] duration:3];
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class]){
        [SVProgressHUD dismiss];
        WBAuthorizeResponse* authResponse = (WBAuthorizeResponse*)response;
        
        //        PD_NSLog(@"%@",response);
//        PD_NSLog(@"\n响应状态:%ld\nuserId:%@\naccessToken:%@\n响应UserInfo数据:%@\n原请求UserInfo数据:%@\n认证过期时间:%@",(long)authResponse.statusCode,authResponse.userID,authResponse.accessToken,response.userInfo,response.requestUserInfo,authResponse.expirationDate);
        
        switch (authResponse.statusCode) {
            case WeiboSDKResponseStatusCodeSuccess:{
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:authResponse.accessToken forKey:PD_ACCESSTOKEN];
                [userDefault setObject:authResponse.userID forKey:PD_USERID];
                [userDefault setObject:authResponse.refreshToken forKey:PD_REFRESHTOKEN];
                [userDefault setInteger:PDAPPLoginTypeSina forKey:PD_APPLOGINBY];//记录app登入方式
                [userDefault synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WBAuthorizeResponseSuccessfulNotification" object:nil];
            }
                break;
            case WeiboSDKResponseStatusCodeUserCancel:{
                [[PDPublicTools sharedPublicTools]showMessage:@"用户取消登录" duration:3];
            }
                break;
            case WeiboSDKResponseStatusCodeUserCancelInstall:{
                [[PDPublicTools sharedPublicTools]showMessage:@"用户取消安装" duration:3];
            }
                break;
            case WeiboSDKResponseStatusCodeShareInSDKFailed:{
                [[PDPublicTools sharedPublicTools]showMessage:@"分享失败" duration:3];
            }
                break;
            default:
                break;
        }
        
    }
}
@end
