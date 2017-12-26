//
//  IMIndexController.m
//  Demo
//
//  Created by 123 on 2017/12/22.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "IMIndexController.h"

@interface IMIndexController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkwebView;

@end

@implementation IMIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    WKUserScript *userScript = [[WKUserScript alloc]initWithSource:@"document.getElementsByClassName('header')[0].style.display = 'none';" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [config.userContentController addUserScript:userScript];
    
    
    WKWebView *wkwebView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    wkwebView.navigationDelegate = self;
    wkwebView.scrollView.bounces = NO;
    wkwebView.scrollView.showsVerticalScrollIndicator = NO;
    wkwebView.scrollView.showsHorizontalScrollIndicator = NO;
    wkwebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:wkwebView];
    self.wkwebView = wkwebView;

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSURLRequest *quest = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [self.wkwebView loadRequest:quest];
}

#pragma mark - WKNavigationDelegate代理方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    webView.scrollView.hidden = YES;
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [webView evaluateJavaScript:@"document.getElementsByClassName('pic-footer')[0].remove();" completionHandler:nil];
        webView.scrollView.hidden = NO;
        [SVProgressHUD dismiss];
    });
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"%@",error);
}
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"Provisional-error == %@",error);
    
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
