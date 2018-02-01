//
//  IMMainViewController.m
//  Demo
//
//  Created by 123 on 2018/1/3.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "IMMainViewController.h"

@interface IMMainViewController ()

@end

@implementation IMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[IMNetworkingTools sharedNetWorkingTools]checkFIRVersionWithCallBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return;
        }
        
        PD_NSLog(@"%@",response);
        NSDictionary *dic = (NSDictionary*)response;
        NSString *changelog = [dic objectForKey:@"changelog"];
        CGFloat version = [[dic objectForKey:@"versionShort"] floatValue];
        NSInteger build = [[dic objectForKey:@"build"] integerValue];
        
        CGFloat currentVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] floatValue];
        NSInteger currentBundle = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue];
        
        if (version != currentVersion || (version == currentVersion && build != currentBundle)) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发现新版本%.1f.%d",version,build] message:changelog preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[dic objectForKey:@"update_url"]]];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:NULL];

        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
