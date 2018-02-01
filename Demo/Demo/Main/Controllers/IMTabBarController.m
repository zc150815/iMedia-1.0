//
//  IMTabBarController.m
//  iMediaTest
//
//  Created by 123 on 2017/12/22.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "IMTabBarController.h"
#import "IMNavigationController.h"
#import "IMNewsController.h"
#import "IMOthersController.h"

@interface IMTabBarController ()

@end

@implementation IMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildController];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self hiddenTopLineToBack];
}
-(void)hiddenTopLineToBack{
    
    for (UIView *lineView in self.tabBar.subviews)
    {
        if ([lineView isKindOfClass:[UIImageView class]] && lineView.bounds.size.height <= 1)
        {
            UIImageView *lineImage = (UIImageView *)lineView;
            [self.tabBar sendSubviewToBack:lineImage];
            
        }
    }
}

+(void)initialize{
    
    UITabBar *tabBar = [UITabBar appearance];
    if (SystemVersion < 10) {
        
        tabBar.barTintColor = [UIColor getColor:COLOR_BROWN_LIGHT];
    }else{
        tabBar.unselectedItemTintColor = [UIColor getColor:COLOR_BROWN_LIGHT];
    }
    tabBar.tintColor = [UIColor getColor:COLOR_BASE];
    [tabBar setBarTintColor:[UIColor whiteColor]];
}
-(void)setupChildController{
    
    [self addChildViewController:[[IMNewsController alloc]init] title:@"新闻" image:@"news_nomal" selectedImage:@"news_selected"];
    [self addChildViewController:[[IMOthersController alloc]init] title:@"我的" image:@"my_nomal" selectedImage:@"my_selected"];
    
}

-(void)addChildViewController:(UIViewController *)childController title:(NSString*)title image:(NSString*)imageName selectedImage:(NSString*)selectedImageName{
    
    [childController.tabBarItem setImage:[UIImage scaleFromImage:[UIImage imageNamed:imageName] toSize:CGSizeMake(24, 24)]];
    [childController.tabBarItem setSelectedImage:[UIImage scaleFromImage:[UIImage imageNamed:selectedImageName] toSize:CGSizeMake(24, 24)]];
    childController.tabBarItem.title = title;
    
    IMNavigationController *nav = [[IMNavigationController alloc]initWithRootViewController:childController];
    [self addChildViewController:nav];
}


@end
