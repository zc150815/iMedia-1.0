//
//  IMModel.h
//  Demo
//
//  Created by 123 on 2017/12/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMModel : NSObject

@property (nonatomic, strong) IMModel *data;

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *login_type;
@property (nonatomic,copy) NSString *wb_openid;
@property (nonatomic,copy) NSString *unionid;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *openid;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *base64nickname;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *tw_openid;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *create_time;


//wechat
@property (nonatomic,copy) NSString *expires_in;
@property (nonatomic,copy) NSString *scope;
@property (nonatomic,copy) NSString *access_token;
@property (nonatomic,copy) NSString *refresh_token;


@end
