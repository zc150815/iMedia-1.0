//
//  IMNewsController.m
//  iMediaTest
//
//  Created by 123 on 2017/12/22.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "IMNewsController.h"
#import "IMIndexController.h"
#import "IMNetworkingTools.h"
#import "ZCSliderView.h"

@interface IMNewsController ()<WKNavigationDelegate,WKUIDelegate,ZCSliderViewDelegate>

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) ZCSliderView *sliderView;
@property (nonatomic, strong) WKWebView *wkwebView;

@end

@implementation IMNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    [self loadData];
    
}
-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZCSliderView *sliderView = [[ZCSliderView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, PD_Fit(30))];
    sliderView.delegate = self;
    sliderView.ZC_TextColor_Nomal = [UIColor getColor:@"000000"];
    sliderView.ZC_TextColor_Selected = [UIColor getColor:COLOR_BASE];
    sliderView.ZC_Font = PD_Font(15);
    sliderView.hidden = YES;
    [self.view addSubview:sliderView];
    self.sliderView = sliderView;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    WKUserScript *userScript = [[WKUserScript alloc]initWithSource:@"document.getElementsByClassName('header')[0].style.display = 'none';document.getElementsByClassName('gotop')[0].remove();" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [config.userContentController addUserScript:userScript];
    
    WKWebView *wkwebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    wkwebView.navigationDelegate = self;
    wkwebView.scrollView.bounces = NO;
    wkwebView.scrollView.showsVerticalScrollIndicator = NO;
    wkwebView.scrollView.showsHorizontalScrollIndicator = NO;
    wkwebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:wkwebView];
    self.wkwebView = wkwebView;
    [wkwebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sliderView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

-(void)loadData{
    
    [SVProgressHUD show];
    [[IMNetworkingTools sharedNetWorkingTools]getNewsChannelDataWithCallBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            NSLog(@"error===%@",error);
            return;
        }
        if ([response isKindOfClass:[NSArray class]]) {
//            NSLog(@"%@",response);
            self.dataArr = (NSArray*)response;
            NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.dataArr.count];
            for (NSDictionary *dic in self.dataArr) {
                [arrayM addObject:[dic objectForKey:@"name"]];
            }
            
            self.sliderView.hidden = NO;
            self.sliderView.sliderArr = arrayM.copy;
            [self ZCSliderView:self.sliderView didSelectItemAtIndex:0];
        }
    }];
}
#pragma mark - ZCSliderViewDelegate代理方法
-(void)ZCSliderView:(ZCSliderView *)sliderView didSelectItemAtIndex:(NSInteger)index{
    
    NSDictionary *dic = self.dataArr[index];
    NSString *url = [dic objectForKey:@"url"];
    NSString *questUrl;
    if (![url hasPrefix:@"http"]) {
        questUrl = [NSString stringWithFormat:@"%@%@",URL_BASE,url];
    }else{
        questUrl = url;
    }
    NSURLRequest *quest = [NSURLRequest requestWithURL:[NSURL URLWithString:questUrl]];
    [self.wkwebView loadRequest:quest];
    
    self.title = [dic objectForKey:@"name"];

}

#pragma mark - WKNavigationDelegate代理方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    webView.scrollView.hidden = YES;
    [SVProgressHUD show];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        webView.scrollView.hidden = NO;
        [SVProgressHUD dismiss];
    });
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        
        [SVProgressHUD show];
        IMIndexController *indexVC = [[IMIndexController alloc]init];
        indexVC.url = [NSString stringWithFormat:@"%@",navigationAction.request.URL];
        indexVC.title = self.title;
        [self.navigationController pushViewController:indexVC animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else{
        
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }
}

-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray new];
    }
    return _dataArr;
}

@end
