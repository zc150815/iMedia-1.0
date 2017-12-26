//
//  PDMacroHeader.h
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#ifndef PDMacroHeader_h
#define PDMacroHeader_h


#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define PhoneIDNum [[[UIDevice currentDevice] identifierForVendor] UUIDString]

/****************************适配**************************************/
#define PD_Iphone6Width 375.0
#define PD_Iphone6Height 667.0
#define PD_Font(f) [UIFont systemFontOfSize:PD_Fit(f)]
#define Font_(f) [UIFont systemFontOfSize:f]
#define PD_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define PD_ScreenHeight [UIScreen mainScreen].bounds.size.height
#define PD_Fit(x) (PD_ScreenHeight*((x)/PD_Iphone6Height))
//#define PD_Fit(x) x

#define PD_FitH(x) (PD_ScreenWidth*((x)/PD_Iphone6Width))
#define PD_RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define PD_RandomColor PD_RGBColor(arc4random() % 256, arc4random() % 256, arc4random() % 256)

#define PD_TabBarHeight ((IMTabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController).tabBar.frame.size.height
#define PD_NavHeight self.navigationController.navigationBar.frame.size.height

/****************************其他**************************************/

//app登录途径
typedef enum : NSUInteger {
    PDAPPLoginTypeIsLogout = 0,
    PDAPPLoginTypeWechat = 2000,
    PDAPPLoginTypeSina,
    PDAPPLoginTypeTwitter,
    PDAPPLoginTypeFacebook,
} PDAPPLoginType;

//app分享途径
typedef enum : NSUInteger {
    PDAPPShareByTypeWechatFriend = 100,
    PDAPPShareByTypeWechatMoments = 200,
    PDAPPShareByTypeSina = 300,
    PDAPPShareByTypeTwitter = 400,
    PDAPPShareByTypeFacebook = 500,
    PDAPPShareByTypeMessage = 600,
    PDAPPShareByTypeMail = 700,
    PDAPPShareByTypeCopyLink = 800,
} PDAPPShareByType;

#endif /* PDMacroHeader_h */
