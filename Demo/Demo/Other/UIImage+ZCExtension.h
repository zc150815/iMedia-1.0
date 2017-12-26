//
//  UIImage+ZCExtension.h
//  ired6
//
//  Created by zhangchong on 2017/2/6.
//  Copyright © 2017年 ired6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZCExtension)

//+ (UIImage *)imageNamedWithStr:(NSString *)name bounds:(CGRect*)bounds;
//+ (UIImage *)imageNamedWithUrlStr:(NSString *)name bounds:(CGRect*)bounds;

+(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size;

-(UIImage*)drawCircleImageWithImage:(UIImage*)image WithCornerRadius:(CGFloat)radius;
@end
