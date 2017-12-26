//
//  IMNavigationController.m
//  iMediaTest
//
//  Created by 123 on 2017/12/22.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "IMNavigationController.h"

@interface IMNavigationController ()

@end

@implementation IMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = (id)self;

}
+(void)initialize{
    
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor getColor:COLOR_BASE];
    [bar setTintColor:[UIColor whiteColor]];
    bar.translucent = NO;
    [bar setShadowImage:[[UIImage alloc]init]];
    [bar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    bar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor getColor:@"FFFFFF"],
                                NSFontAttributeName:[UIFont systemFontOfSize:18]};
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {
        //返回按钮
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backImg = [UIImage imageNamed:@"back"];
        [leftButton setImage:[UIImage scaleFromImage:backImg toSize:CGSizeMake(21/backImg.size.height*backImg.size.width, 21)] forState:UIControlStateNormal];
        leftButton.bounds = CGRectMake(0, 0, 50, 21);
        leftButton.adjustsImageWhenHighlighted = NO;
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftButton addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *shareImg = [UIImage imageNamed:@"share"];
        [rightButton setImage:[UIImage scaleFromImage:shareImg toSize:CGSizeMake(21/shareImg.size.height*shareImg.size.width, 21)] forState:UIControlStateNormal];
        rightButton.bounds = CGRectMake(0, 0, 50, 21);
        rightButton.adjustsImageWhenHighlighted = NO;
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightButton addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    [super pushViewController:viewController animated:animated];
    
}
-(void)popController{
    [self popViewControllerAnimated:YES];
}
-(void)shareBtnClick{
    
}
//修改状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    [super preferredStatusBarStyle];
    
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
