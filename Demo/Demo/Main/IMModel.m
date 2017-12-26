//
//  IMModel.m
//  Demo
//
//  Created by 123 on 2017/12/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "IMModel.h"

@implementation IMModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
