//
//  IMQQService.h
//  Demo
//
//  Created by 123 on 2017/12/27.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^QQCallBack)(id response,NSError* error);

@interface IMQQService : NSObject


+(void)initQQService;

+(void)logoutQQService;
@end
