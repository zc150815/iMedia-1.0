//
//  PDPublicTools.h
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDPublicTools : NSObject


+(instancetype)sharedPublicTools;
#pragma mark
#pragma mark 缓存计算方法
//读取缓存
-(NSString*)loadSystemCache;

#pragma mark
#pragma mark 提示框
//显示提示框
-(void)showMessage:(NSString *)message duration:(NSTimeInterval)time;
//判断手机号
- (BOOL)judgePhoneNumber:(NSString *)phoneNum;
//判断密码
- (BOOL)judgePassword:(NSString *)password;
//判断是否为邮箱
+(BOOL)judegeEmailAdress:(NSString *)Email;
//判断是否为银行卡
+(BOOL)judegeBankCard:(NSString *)cardNumber;
//判断是否是身份证号
+(BOOL)judgeIDCardNumber:(NSString*)IDCardNumber;


@end
