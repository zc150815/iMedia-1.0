//
//  UIImage+ZCExtension.m
//  ired6
//
//  Created by zhangchong on 2017/2/6.
//  Copyright © 2017年 ired6. All rights reserved.
//

#import "UIImage+ZCExtension.h"

@implementation UIImage (ZCExtension)


+(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size

{
    
    if([[UIScreen mainScreen] scale] == 2.0){ // @2x
        
        UIGraphicsBeginImageContextWithOptions(size,NO, 2.0);
        
    }else if([[UIScreen mainScreen]scale]== 3.0){ // @3x ( iPhone 6plus 、iPhone6s plus)
        
        UIGraphicsBeginImageContextWithOptions(size,NO, 3.0);
        
    }else{
        
        UIGraphicsBeginImageContext(size);
        
    }
    
    // 绘制改变大小的图片
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage* scaledImage =
    
    UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    
    return scaledImage;
    
}
-(UIImage*)drawCircleImageWithImage:(UIImage*)image WithCornerRadius:(CGFloat)radius{
    
    UIGraphicsBeginImageContext(CGSizeMake(radius, radius));
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(radius, radius), NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, radius, radius) cornerRadius:radius] addClip];
    
    [image drawInRect:CGRectMake(0, 0, radius, radius)];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
    
}

@end
