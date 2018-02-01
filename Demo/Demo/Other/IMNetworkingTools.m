//
//  IMNetworkingTools.m
//  Demo
//
//  Created by 123 on 2017/12/25.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "IMNetworkingTools.h"

@implementation IMNetworkingTools

//单例创建对象
+(IMNetworkingTools*)sharedNetWorkingTools{
    
    static dispatch_once_t onceToken;
    static IMNetworkingTools* instanceType;
    dispatch_once(&onceToken, ^{
        instanceType = [[self alloc]init];
        instanceType.responseSerializer = [AFJSONResponseSerializer serializer];//解决3840
//        instanceType.requestSerializer.timeoutInterval = 10;
    });
    return instanceType;
}

#pragma mark
#pragma mark 封装get/post请求
-(void)requestWithRequestType:(RequestType)type url:(NSString*)url params:(NSDictionary*)params callBack:(callBack)callBack {
    if (type == GET) {
        [[IMNetworkingTools sharedNetWorkingTools] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callBack(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(nil,error);
        }];
    }else{
        [[IMNetworkingTools sharedNetWorkingTools] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callBack(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(nil,error);
        }];
    }
}

-(void)getNewsChannelDataWithCallBack:(callBack)callBack{
    NSString*url = @"http://10.45.32.213:8080/json/channel_list.jspx";
    [self requestWithRequestType:GET url:url params:nil callBack:callBack];
}

-(void)loginSuccessfulWithLoginType:(PDAPPLoginType)type userID:(NSString*)ID userName:(NSString*)name headeImagURL:(NSString*)URL CallBack:(callBack)callBack{
    NSString *typeStr;
    switch (type) {
        case PDAPPLoginTypeWechat:{
            typeStr = @"wx";
        }
            break;
        case PDAPPLoginTypeSina:{
            typeStr = @"weibo";
        }
            break;
        case PDAPPLoginTypeQQ:{
            typeStr = @"twitter";
        }
            break;
        case PDAPPLoginTypeFacebook:{
            typeStr = @"facebook";
        }
            break;
        default:
            break;
    }
    NSString *url = [NSString stringWithFormat:@"http://114.115.148.47/api/login/%@_login",typeStr];
    NSDictionary *params = @{@"openid":ID,@"nickname":name,@"headimgurl":URL};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];
}

//微信登录获取accessToken
-(void)getWechatAccessTokenWithCode:(NSString*)code CallBack:(callBack)callBack{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [manager GET:@"https://api.weixin.qq.com/sns/oauth2/access_token" parameters:@{@"appid":WECHATAPPID,@"secret":WECHATAPPSECRET,@"code":code,@"grant_type":@"authorization_code"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(nil,error);
    }];
    
}
//微信登录获取用户信息
-(void)getWechatUserInfoWithCallBack:(callBack)callBack{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:PD_ACCESSTOKEN];
    NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:PD_USERID];
    [manager GET:@"https://api.weixin.qq.com/sns/userinfo" parameters:@{@"access_token":accessToken,@"openid":userID,@"lang":@"en"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(nil,error);
    }];
}

//微博登录获取用户信息
-(void)getWeiboUserInfoWithCallBack:(callBack)callBack{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:PD_ACCESSTOKEN];
    NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:PD_USERID];
    [manager GET:@"https://api.weibo.com/2/users/show.json" parameters:@{@"access_token":accessToken,@"uid":@(userID.integerValue)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(nil,error);
    }];
    
}

//QQ登录获取用户信息
-(void)getQQUserInfoWithCallBack:(callBack)callBack{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:PD_ACCESSTOKEN];
    NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:PD_USERID];
    NSString *appID = [[NSUserDefaults standardUserDefaults]objectForKey:PD_APPID];
    [manager GET:@"https://graph.qq.com/user/get_user_info" parameters:@{@"access_token":accessToken,@"openid":userID,@"oauth_consumer_key":appID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(nil,error);
    }];
}



-(void)checkFIRVersionWithCallBack:(callBack)callBack{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    NSString *url = [NSString stringWithFormat:@"http://api.fir.im/apps/latest/%@",@"5a4b6f0a959d692f020007e9"];
    [manager GET:url parameters:@{@"api_token":@"faaa8aa9cb38d14c63d70194112194bd"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(nil,error);
    }];
}

@end
