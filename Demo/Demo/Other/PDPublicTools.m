//
//  PDPublicTools.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDPublicTools.h"

@interface PDPublicTools ()

@property (nonatomic, strong) UIView *showview;//提示视图

@property (nonatomic,assign) BOOL isShowing;


@end
@implementation PDPublicTools

static PDPublicTools* _instanceType;
+(instancetype)sharedPublicTools{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceType = [[self alloc]init];
    });
    return _instanceType;
}

#pragma mark
#pragma mark 缓存计算方法
//读取缓存
-(NSString*)loadSystemCache{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    CGFloat size = [self folderSizeAtPath:cachePath];
    if (size == 0) {
        return nil;
    }
    NSString *message = size > 1 ? [NSString stringWithFormat:@"缓存%.2fM",size] : [NSString stringWithFormat:@"缓存%.2fKb", size*1024.0];
    return message;
}
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}


#pragma mark  提示条
-(void)showMessage:(NSString *)message duration:(NSTimeInterval)time
{
//    if (_isShowing) {
//        return;
//    }
    _isShowing = YES;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.alpha = 0;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    self.showview = showview;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = message;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = PD_Font(15);
    label.x = MARGIN_BASE;
    label.y = MARGIN_BASE/2;
    [label sizeToFit];
    [showview addSubview:label];
    showview.center = CGPointMake(window.centerX, window.height*3/4);
    showview.bounds = CGRectMake(0, 0, label.width+MARGIN_BASE*2, label.height+MARGIN_BASE);
    [window bringSubviewToFront:showview];
    
    
    [UIView animateWithDuration:time/2 animations:^{
        showview.alpha = 0.7;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:time/2 animations:^{
            showview.alpha = 0;
        } completion:^(BOOL finished) {
            [showview removeFromSuperview];
            _isShowing = NO;
        }];
    }];
}
//判断是否为邮箱
+(BOOL)judegeEmailAdress:(NSString *)Email{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}

//判断是否为银行卡
+(BOOL)judegeBankCard:(NSString *)cardNumber{
    if(cardNumber.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++)
    {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

//判断是否是身份证号
+(BOOL)judgeIDCardNumber:(NSString*)IDCardNumber{
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}
// 判断是否是11位手机号码
- (BOOL)judgePhoneNumber:(NSString *)phoneNum{
    
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(17[3,7])|(18[0,1,9]))\\d{8}$";
    
    // 一个判断是否是手机号码的正则表达式
    NSString *pattern = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",CM_NUM,CU_NUM,CT_NUM];
    
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString *mobile = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) {
        return NO;
    }
    
    // 无符号整型数据接收匹配的数据的数目
    NSUInteger numbersOfMatch = [regularExpression numberOfMatchesInString:mobile options:NSMatchingReportProgress range:NSMakeRange(0, mobile.length)];
    if (numbersOfMatch>0) return YES;
    
    return NO;
    
}
// 判断密码是否符合规则
- (BOOL)judgePassword:(NSString *)password{
    
    BOOL result = NO;
    NSInteger length = password.length;
    if (length >= 8 && length <= 16 ){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:password];
    }
    return result;
}


@end
