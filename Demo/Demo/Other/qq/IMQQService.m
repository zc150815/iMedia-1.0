//
//  IMQQService.m
//  Demo
//
//  Created by 123 on 2017/12/27.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "IMQQService.h"

@interface IMQQService ()<QQApiInterfaceDelegate,TencentSessionDelegate>

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
+(void)getUserInfoWithCallBack:(QQCallBack)callBack{
    [[self sharedQQService]getUserInfoWithCallBack:callBack];
}
-(void)initQQService{
    
    TencentOAuth *tencentOAuth  = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:self];

    NSArray *permissions = @[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_SHARE, kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO];
    [tencentOAuth authorize:permissions inSafari:NO];
    self.tencentOAuth = tencentOAuth;
    
}
-(void)getUserInfoWithCallBack:(QQCallBack)callBack{
    [self.tencentOAuth getUserInfo];
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
        //  记录登录用户的OpenID、Token以及过期时间
        NSLog(@"QQaccessToken = %@",self.tencentOAuth.accessToken);

        [self.tencentOAuth setAccessToken:self.tencentOAuth.accessToken] ;
        [self.tencentOAuth setOpenId:self.tencentOAuth.openId] ;
        [self.tencentOAuth setExpirationDate:self.tencentOAuth.expirationDate] ;
        [self.tencentOAuth getUserInfo];

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
/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response{
    
    if (!response.errorMsg) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setInteger:PDAPPLoginTypeQQ forKey:PD_APPLOGINBY];//记录app登入方式
        [userDefault synchronize];
        
        NSLog(@"getUserInfoResponse==%@",response);
        NSLog(@"%@",response.jsonResponse);
        
        NSString *nickName = [response.jsonResponse objectForKey:@"nickname"];
        NSString *figureurl = [response.jsonResponse objectForKey:@"figureurl_2"];
        
        NSDictionary *userInfo = @{@"nickname":nickName,@"headimgurl":figureurl,@"openID":self.tencentOAuth.openId};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QQAuthorizeResponseSuccessfulNotification" object:nil userInfo:userInfo];

    }else{
        NSLog(@"errorMsg == %@",response.errorMsg);
    }
    
//    figureurl_2 : http://qzapp.qlogo.cn/qzapp/1106639630/7153ED83D5F4E3A0DFB3145A248CA385/100
//    nickname : 张冲 荣之联,

}

-(void)tencentDidLogout{
    
    [[PDPublicTools sharedPublicTools]showMessage:@"登出成功" duration:3];
}
#pragma mark - QQApiInterfaceDelegate代理方法
/**
 处理来至QQ的请求
 */
-(void)onReq:(QQBaseReq *)req{
    
    NSLog(@"onReq==%@",req);
}

/**
 处理来至QQ的响应
 */
-(void)onResp:(QQBaseResp *)resp{
    NSLog(@"onResp==%@",resp);
}

/**
 处理QQ在线状态的回调
 */
-(void)isOnlineResponse:(NSDictionary *)response{
    NSLog(@"isOnlineResponse==%@",response);
}
@end
