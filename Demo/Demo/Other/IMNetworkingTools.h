//
//  IMNetworkingTools.h
//  Demo
//
//  Created by 123 on 2017/12/25.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking.h>

typedef enum : NSUInteger {
    GET = 0,
    POST = 1,
} RequestType;

typedef void (^callBack)(id response,NSError* error);


@interface IMNetworkingTools : AFHTTPSessionManager

+(instancetype)sharedNetWorkingTools;

-(void)getNewsChannelDataWithCallBack:(callBack)callBack;
-(void)loginSuccessfulWithLoginType:(PDAPPLoginType)type userID:(NSString*)ID userName:(NSString*)name headeImagURL:(NSString*)URL CallBack:(callBack)callBack;

//微信登录获取accessToken
-(void)getWechatAccessTokenWithCode:(NSString*)code CallBack:(callBack)callBack;
//微信登录获取用户信息
-(void)getWechatUserInfoWithCallBack:(callBack)callBack;
//微博登录获取用户信息
-(void)getWeiboUserInfoWithCallBack:(callBack)callBack;
@end
