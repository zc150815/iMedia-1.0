//
//  AppDelegate+WeixinService.m
//  Demo
//
//  Created by 123 on 2017/12/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "AppDelegate+WeixinService.h"
#import "IMModel.h"
#import "IMNetworkingTools.h"

@implementation AppDelegate (WeixinService)

-(void)initWeixinService{
    [WXApi registerApp:WECHATAPPID];
}

//微信接收响应
-(void)onResp:(BaseResp *)resp{
    [[PDPublicTools sharedPublicTools]showMessage:@"resp" duration:3];
    //    PD_NSLog(@"req = %@",resp);
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *response = (SendAuthResp*)resp;
        NSString *showM;
        switch (response.errCode) {
            case 0:{//ERR_OK = 0(用户同意)
                if (response.code) {
                    showM = [NSString stringWithFormat:@"code=%@\nstate=%@\nlang=%@\ncountry=%@",response.code,response.state,response.lang,response.country];
                    
//                    [[PDPublicTools sharedPublicTools]showMessage:showM duration:5];
                    //                    PD_NSLog(@"%@",showM);
                    [self WXOauthSuccessful:response.code];
                }
            }
                break;
            case -2:{//ERR_USER_CANCEL = -2（用户取消）
            }
                break;
            case -4:{//ERR_AUTH_DENIED = -4（用户拒绝授权）
            }
                break;
            default:
                break;
        }
        
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        SendMessageToWXResp *response = (SendMessageToWXResp*)resp;
        //        PD_NSLog(@"\nlang:%@\ncounty:%@",response.lang,response.country);
        
    }
}

//获取微信accessToken
-(void)WXOauthSuccessful:(NSString*)code{
    
    [[IMNetworkingTools sharedNetWorkingTools]getWechatAccessTokenWithCode:code CallBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            //            PD_NSLog(@"error===%@",error);
            return;
        }
        
        //        PD_NSLog(@"%@",response);
        IMModel *model = [IMModel mj_objectWithKeyValues:response];
        if (model.access_token.length) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:model.access_token forKey:PD_ACCESSTOKEN];
            [userDefault setObject:model.openid forKey:PD_USERID];
            [userDefault setObject:model.refresh_token forKey:PD_REFRESHTOKEN];
            [userDefault setInteger:PDAPPLoginTypeWechat forKey:PD_APPLOGINBY];//记录app登入方式
            [userDefault synchronize];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"WXAuthorizeResponseSuccessfulNotification" object:nil];
        }
    }];
}
@end
