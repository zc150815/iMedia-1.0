//
//  IMQQService.m
//  Demo
//
//  Created by 123 on 2017/12/27.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "IMQQService.h"

@interface IMQQService ()<TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end

@implementation IMQQService

//单例创建对象
+(IMQQService*)sharedQQService{
    
    static dispatch_once_t onceToken;
    static IMQQService* instanceType;
    dispatch_once(&onceToken, ^{
        instanceType = [[self alloc]init];
    });
    return instanceType;
}
+(void)initQQService{
    [[self sharedQQService]initQQService];
}
+(void)logoutQQService{
    [[self sharedQQService]logoutQQService];
}

-(void)initQQService{
    
    TencentOAuth *tencentOAuth  = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:self];

    NSArray *permissions = @[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_SHARE, kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO];
    [tencentOAuth authorize:permissions];
    self.tencentOAuth = tencentOAuth;
    
}
-(void)logoutQQService{
    
    [self.tencentOAuth logout:self];
}
#pragma mark - TencentLoginDelegate代理方法
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    
    NSLog(@"登录成功后的回调");
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length]){
//          记录登录用户的OpenID、Token以及过期时间
//        NSLog(@"QQaccessToken = %@ appId == %@",self.tencentOAuth.accessToken,self.tencentOAuth.appId);

        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:self.tencentOAuth.accessToken forKey:PD_ACCESSTOKEN];
        [userDefault setObject:self.tencentOAuth.openId forKey:PD_USERID];
        [userDefault setObject:self.tencentOAuth.expirationDate forKey:PD_EXPIRATIONDATE];
        [userDefault setObject:self.tencentOAuth.appId forKey:PD_APPID];
        [userDefault setInteger:PDAPPLoginTypeQQ forKey:PD_APPLOGINBY];//记录app登入方式
        [userDefault synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QQAuthorizeResponseSuccessfulNotification" object:nil];
    }
    
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    NSLog(@"登录失败后的回调");
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    NSLog(@"登录时网络有问题的回调");
}




#pragma mark - TencentSessionDelegate代理方法
-(void)tencentDidLogout{
    [[PDPublicTools sharedPublicTools]showMessage:@"登出成功" duration:3];
}

@end
