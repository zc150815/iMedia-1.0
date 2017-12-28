//
//  IMIndexController.m
//  Demo
//
//  Created by 123 on 2017/12/22.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "IMIndexController.h"

@interface IMIndexController ()<WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *wkwebView;

@property (nonatomic,copy) NSString *shareURL;
@property (nonatomic,copy) NSString *shareTitle;
@property (nonatomic,copy) NSString *shareText;
@property (nonatomic,copy) NSString *shareImgURL;


@end

@implementation IMIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shareImg = [UIImage imageNamed:@"share"];
    [rightButton setImage:[UIImage scaleFromImage:shareImg toSize:CGSizeMake(21/shareImg.size.height*shareImg.size.width, 21)] forState:UIControlStateNormal];
    rightButton.bounds = CGRectMake(0, 0, 50, 21);
    rightButton.adjustsImageWhenHighlighted = NO;
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    WKUserScript *userScript = [[WKUserScript alloc]initWithSource:@"document.getElementsByClassName('header')[0].style.display = 'none';" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [config.userContentController addUserScript:userScript];
    [config.userContentController addScriptMessageHandler:self name:@""];
    
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
        
        //去除底部的多余的标签
        [webView evaluateJavaScript:@"document.getElementsByClassName('pic-footer')[0].remove();" completionHandler:nil];
        
        //获取当前页面的titile
        [webView evaluateJavaScript:@"document.getElementsByClassName('content-title')[0].innerHTML" completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
            if (!error) {
                self.shareTitle = htmlStr;
            }
        }];
        
        [webView evaluateJavaScript:@"document.body.outerHTML" completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
            if (error) {
                NSLog(@"JSError:%@",error);
            }
//            NSLog(@"html:%@",htmlStr);
        }];
        
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


-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    self.shareURL = [NSString stringWithFormat:@"%@",navigationResponse.response.URL];

    decisionHandler(WKNavigationResponsePolicyAllow);
}
#pragma mark - WKScriptMessageHandler代理方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"WKScriptMessageHandler == %@",message);
}
#pragma mark - 分享
-(void)shareBtnClick{
    
}
@end
