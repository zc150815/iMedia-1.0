//
//  PDParameterHeader.h
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/30.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#ifndef PDParameterHeader_h
#define PDParameterHeader_h

/****************************分享/登录**************************************/
static NSString * const Appkey_ShareSDK = @"21f11f7e82894"; //Appkey_ShareSDK
static NSString * const AppSecret_ShareSDK = @"f9d86fbac181c67a2d6761fb31fb9dac"; //AppSecret_ShareSDK

static NSString * const Appkey_Weibo = @"748044815"; //Appkey_Weibo
static NSString * const AppSecret_Weibo = @"1dc727ad120186323b563be7b512bb88"; //AppSecret_Weibo
static NSString * const RedirectURL_Weibo = @"http://en.peopleapp.com"; //RedirectURL_Weibo

/****************************间距**************************************/
static CGFloat const MARGIN_BASE = 15.0;
static CGFloat const MARGIN_LARGE = 20.0;
static CGFloat const MARGIN_LITTLE = 10.0;
//static NSString * const APPURL = @"https://itunes.apple.com/cn/app/%E7%BA%A2%E5%85%AD/id1236645774?mt=8";


/****************************颜色**************************************/
static NSString * const COLOR_BASE = @"4C6CFF"; //主色调
static NSString * const COLOR_BROWN_DEEP = @"343434";//深灰色
static NSString * const COLOR_BROWN_LIGHT = @"888888";//浅灰色
static NSString * const COLOR_BORDER_BASE = @"e6e6e6";//边框颜色
/****************************其他**************************************/
static NSString * const STATUS = @"status";//status
static NSString * const DATA = @"data";//data


//微信
static NSString * const WECHATAPPID = @"wxcd5118d435ade7d7";//微信APPID
static NSString * const WECHATAPPSECRET = @"0c57be6105293b459d66ef64eb8333c4";//微信APPSECRET
//微博
static NSString * const SINAAPPID = @"363528080";//新浪AAPPID
static NSString * const SINAREDIRECTURL = @"https://api.weibo.com/oauth2/default.html";//新浪REDIRECTURL
static NSString * const SINAAPPSECRET = @"b74b9e8e20c7df96a2708f613559c1ff";//新浪APPSECRET
//个推
//static NSString * const GETUIAPPID = @"EDchxZ91qfAxiCM8cQGM27";//个推APPID
//static NSString * const GETUIAPPSECRET = @"SyuC6MWwMkAy7WDiOam1r";//个推APPSECRET
//static NSString * const GETUIAPPKEY = @"SK6GmXbBFW7TcGL7s9JJa6";//个推APPKEY
static NSString * const GETUIAPPID = @"w32RlutEdLAeea7ri5DK85";//个推APPID
static NSString * const GETUIAPPSECRET = @"rRHyuyEkfx9edqdLnQZ7i6";//个推APPSECRET
static NSString * const GETUIAPPKEY = @"C72XoWKbez8t3yI0ujg2p7";//个推APPKEY
//极光
static NSString * const JPUSHAPPKEY = @"96999c3163960ab908f4ec91";//极光APPID


/****************************偏好设置**************************************/
static NSString * const PD_APPUID = @"PD_APPUID";//APP后台用户id
static NSString * const PD_APPTOKEN = @"PD_APPTOKEN";//APP后台用户token
static NSString * const PD_APPLOGINBY = @"PD_APPLOGINBY";//APP登入方式(微博:SINA,微信:WECHAT,推特:TWITTER,facebook:FACEBOOK)
static NSString * const PD_ACCESSTOKEN = @"PD_ACCESSTOKEN";//accessToken
static NSString * const PD_USERID = @"PD_USERID";//微博userId
static NSString * const PD_REFRESHTOKEN = @"PD_REFRESHTOKEN";//微博refreshToken










#endif /* PDParameterHeader_h */
