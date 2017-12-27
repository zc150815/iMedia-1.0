//
//  IMOthersController.m
//  iMediaTest
//
//  Created by 123 on 2017/12/22.
//  Copyright © 2017年 ronglian. All rights reserved.
//
//#import "AppDelegate.h"
//#import "AppDelegate+QQService.h"
#import "IMOthersController.h"
#import "IMIndexController.h"
#import "IMModel.h"
#import "IMNetworkingTools.h"
#import "IMQQService.h"

@interface IMOthersController ()<UITableViewDelegate,UITableViewDataSource,WBHttpRequestDelegate>

@property (nonatomic, strong) UIButton *userInfo;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIView * loginView;

@end

@implementation IMOthersController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful:) name:@"WBAuthorizeResponseSuccessfulNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful:) name:@"WXAuthorizeResponseSuccessfulNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful:) name:@"QQAuthorizeResponseSuccessfulNotification" object:nil];
    
    [self setupUI];
    [self judgeIsOnLine];
    
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *userInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    userInfo.adjustsImageWhenHighlighted = NO;
    [userInfo setBackgroundColor:[UIColor getColor:COLOR_BASE]];
    UIImage *userImg = [UIImage scaleFromImage:[UIImage imageNamed:@"default_head"] toSize:CGSizeMake(60, 60)];
    [userInfo setImage:[[UIImage alloc]drawCircleImageWithImage:userImg WithCornerRadius:userImg.size.width] forState:UIControlStateNormal];
    [userInfo setTitle:@"用户名" forState:UIControlStateNormal];
    userInfo.titleLabel.font = [UIFont systemFontOfSize:15];
    [userInfo setTitleColor:[UIColor getColor:@"ffffff"] forState:UIControlStateNormal];
    userInfo.frame = CGRectMake(0, 0, self.view.width, 120);
    userInfo.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    userInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [userInfo setTitleEdgeInsets:UIEdgeInsetsMake(userInfo.imageView.frame.size.height+15,-userInfo.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [userInfo setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -userInfo.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    self.userInfo = userInfo;
    [self.view addSubview:userInfo];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userInfo.frame), self.view.width, self.view.height-self.userInfo.height)];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.rowHeight = PD_Fit(50);
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    [self loadData];
}
-(void)loadData{
    self.dataArr = @[
                     @{@"title":@"下载",@"imageStr":@"others",@"indexStr":@"http://10.45.32.213:8080/download/index.jhtml"},
                     @{@"title":@"招聘",@"imageStr":@"others",@"indexStr":@"http://10.45.32.213:8080/job/index.jhtml"},
                     @{@"title":@"官网",@"imageStr":@"others",@"indexStr":@"http://www.ronglian.com"},
                     @{@"title":@"网络调查",@"imageStr":@"others",@"indexStr":@"http://10.45.32.213:8080/wldc.jhtml"},
                     @{@"title":@"留言板",@"imageStr":@"others",@"indexStr":@"http://10.45.32.213:8080/guestbook.jspx"},
                     @{@"title":@"论坛",@"imageStr":@"others",@"indexStr":@"http://bbs.ronglian.com"}
                     ];
    [self.tableView reloadData];
}
#pragma mark 判断当前用户是否在线
-(void)judgeIsOnLine{
    
    switch ([[NSUserDefaults standardUserDefaults]integerForKey:PD_APPLOGINBY]) {
        case PDAPPLoginTypeIsLogout://没有登录过
            [self logoutSuccessful];
            break;
        default://最近已经登录过
            [self loginSuccessful:nil];
            break;
    }
}
#pragma mark 加载用户数据
-(void)loadUserInfoData{
    
    switch ([[NSUserDefaults standardUserDefaults]integerForKey:PD_APPLOGINBY]) {
        case PDAPPLoginTypeWechat:{
            
            [[IMNetworkingTools sharedNetWorkingTools]getWechatUserInfoWithCallBack:^(id response, NSError *error) {
                if (error) {
                    [SVProgressHUD dismiss];
                    [[PDPublicTools sharedPublicTools]showMessage:@"登录超时,请重新登录" duration:3];
                    [self logoutSuccessful];
                    //                    PD_NSLog(@"error===error===%@",error);
                    return;
                }
                NSLog(@"加载微信用户信息\n%@",response);
                NSString *name = response[@"nickname"];
                NSString *url = response[@"headimgurl"];
                [self pullLoginUserInfoWithLoginType:PDAPPLoginTypeSina userID:[[NSUserDefaults standardUserDefaults]objectForKey:PD_USERID] userName:name headeImagURL:url];
            }];
        }
            break;
        case PDAPPLoginTypeSina:{
            [[IMNetworkingTools sharedNetWorkingTools]getWeiboUserInfoWithCallBack:^(id response, NSError *error) {
                if (error) {
                    [SVProgressHUD dismiss];
                    [[PDPublicTools sharedPublicTools]showMessage:@"登录超时,请重新登录" duration:3];
                    [self logoutSuccessful];
                    //                    PD_NSLog(@"error===error===%@",error);
                    return;
                }
                //                PD_NSLog(@"加载新浪用户信息\n%@",response);
                NSString *name = response[@"screen_name"];
                NSString *url = response[@"profile_image_url"];
                
                [self pullLoginUserInfoWithLoginType:PDAPPLoginTypeSina userID:[[NSUserDefaults standardUserDefaults]objectForKey:PD_USERID] userName:name headeImagURL:url];
                
            }];
        }
            break;
        case PDAPPLoginTypeQQ:{
            
        }
            break;
        case PDAPPLoginTypeFacebook:{
            
        }
            break;
        default:
            break;
    }
}
#pragma mark 添加logout按钮
-(void)setupLogoutItem{
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor getColor:@"ffffff"] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    logoutBtn.adjustsImageWhenHighlighted = NO;
    logoutBtn.bounds = CGRectMake(0, 0, 70, 20);
    [logoutBtn addTarget:self action:@selector(logoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:logoutBtn];
    
}
#pragma mark 添加快速登录视图
-(UIView *)loginView{
    
    if (!_loginView) {
        
        _loginView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_BASE, 0, self.view.width-2*MARGIN_BASE, 0)];
        _loginView.backgroundColor = [UIColor whiteColor];
        _loginView.layer.cornerRadius = 10;
        _loginView.layer.shadowColor = [UIColor getColor:COLOR_BASE].CGColor;
        _loginView.layer.shadowRadius = 5;
        _loginView.layer.shadowOpacity = 0.5;
        _loginView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        _loginView.height = 250;
        
        UIButton *log_wx = [UIButton buttonWithType:UIButtonTypeCustom];
        log_wx.tag = PDAPPLoginTypeWechat;
        log_wx.adjustsImageWhenHighlighted = NO;
        UIImage *wxImg =[UIImage scaleFromImage:[UIImage imageNamed:@"wechat"] toSize:CGSizeMake(45,45)];
        [log_wx setImage:wxImg forState:UIControlStateNormal];
        [log_wx setTitle:@"Please Sign In" forState:UIControlStateNormal];
        log_wx.titleLabel.font = [UIFont systemFontOfSize:13];
        [log_wx setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
        log_wx.frame = CGRectMake(0, 25, _loginView.width, wxImg.size.height);
        [log_wx addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        log_wx.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        log_wx.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [log_wx setTitleEdgeInsets:UIEdgeInsetsMake(log_wx.imageView.frame.size.height+20,-log_wx.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [log_wx setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -log_wx.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
        [_loginView addSubview:log_wx];
        
        UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(15, _loginView.height/2+15, _loginView.width-2*15, 1)];
        lines.backgroundColor = [UIColor getColor:@"e6e6e6"];
        lines.alpha = 0.5;
        [_loginView addSubview:lines];
        
        UILabel *words = [[UILabel alloc]init];
        words.text = @"Or";
        words.font = [UIFont systemFontOfSize:17];
        words.textAlignment = NSTextAlignmentCenter;
        words.textColor = [UIColor getColor:@"888888"];
        words.backgroundColor = [UIColor whiteColor];
        words.bounds = CGRectMake(0, 0, 50, 30);
        words.center = lines.center;
        [_loginView addSubview:words];
        
        
        NSArray *imgArr = @[@"sina",@"tencentqq",@"facebook"];
        CGFloat btnWith = 40;
        CGFloat margin = (_loginView.width - imgArr.count*btnWith)/(imgArr.count+1);
        for (NSInteger i = 0; i < imgArr.count; i++) {
            NSString *imgStr = imgArr[i];
            
            UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.tag = PDAPPLoginTypeSina+i;
            loginBtn.adjustsImageWhenHighlighted = NO;
            UIImage *btnImg = [UIImage scaleFromImage:[UIImage imageNamed:imgStr] toSize:CGSizeMake(btnWith, btnWith)];
            [loginBtn setImage:btnImg forState:UIControlStateNormal];
            loginBtn.bounds = CGRectMake(0, 0, btnImg.size.width, btnImg.size.height);
            loginBtn.center = CGPointMake(margin+i*(margin+btnWith)+btnWith/2, (_loginView.height-CGRectGetMaxY(words.frame))/2+CGRectGetMaxY(words.frame));
            [loginBtn addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_loginView addSubview:loginBtn];
        }
        
    }
    return _loginView;
}
-(void)setupLoginView{
    
//    UIView * loginView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_BASE, 0, self.view.width-2*MARGIN_BASE, 0)];
//    loginView.backgroundColor = [UIColor whiteColor];
//    loginView.layer.cornerRadius = 10;
//    loginView.layer.shadowColor = [UIColor getColor:COLOR_BASE].CGColor;
//    loginView.layer.shadowRadius = 5;
//    loginView.layer.shadowOpacity = 0.5;
//    loginView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
//    loginView.height = 250;
//    self.loginView = loginView;
    [self.view addSubview:self.loginView];
    
    
//    UIButton *log_wx = [UIButton buttonWithType:UIButtonTypeCustom];
//    log_wx.tag = PDAPPLoginTypeWechat;
//    log_wx.adjustsImageWhenHighlighted = NO;
//    UIImage *wxImg =[UIImage scaleFromImage:[UIImage imageNamed:@"wechat"] toSize:CGSizeMake(45,45)];
//    [log_wx setImage:wxImg forState:UIControlStateNormal];
//    [log_wx setTitle:@"Please Sign In" forState:UIControlStateNormal];
//    log_wx.titleLabel.font = [UIFont systemFontOfSize:13];
//    [log_wx setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
//    log_wx.frame = CGRectMake(0, 25, loginView.width, wxImg.size.height);
//    [log_wx addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    log_wx.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//    log_wx.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    [log_wx setTitleEdgeInsets:UIEdgeInsetsMake(log_wx.imageView.frame.size.height+20,-log_wx.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
//    [log_wx setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -log_wx.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
//    [loginView addSubview:log_wx];
//
//    UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(15, loginView.height/2+15, loginView.width-2*15, 1)];
//    lines.backgroundColor = [UIColor getColor:@"e6e6e6"];
//    lines.alpha = 0.5;
//    [loginView addSubview:lines];
//
//    UILabel *words = [[UILabel alloc]init];
//    words.text = @"Or";
//    words.font = [UIFont systemFontOfSize:17];
//    words.textAlignment = NSTextAlignmentCenter;
//    words.textColor = [UIColor getColor:@"888888"];
//    words.backgroundColor = [UIColor whiteColor];
//    words.bounds = CGRectMake(0, 0, 50, 30);
//    words.center = lines.center;
//    [loginView addSubview:words];
//
//
//    NSArray *imgArr = @[@"sina",@"tencentqq",@"facebook"];
//    CGFloat btnWith = 40;
//    CGFloat margin = (loginView.width - imgArr.count*btnWith)/(imgArr.count+1);
//    for (NSInteger i = 0; i < imgArr.count; i++) {
//        NSString *imgStr = imgArr[i];
//
//        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        loginBtn.tag = PDAPPLoginTypeSina+i;
//        loginBtn.adjustsImageWhenHighlighted = NO;
//        UIImage *btnImg = [UIImage scaleFromImage:[UIImage imageNamed:imgStr] toSize:CGSizeMake(btnWith, btnWith)];
//        [loginBtn setImage:btnImg forState:UIControlStateNormal];
//        loginBtn.bounds = CGRectMake(0, 0, btnImg.size.width, btnImg.size.height);
//        loginBtn.center = CGPointMake(margin+i*(margin+btnWith)+btnWith/2, (loginView.height-CGRectGetMaxY(words.frame))/2+CGRectGetMaxY(words.frame));
//        [loginBtn addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [loginView addSubview:loginBtn];
//    }
//
    self.tableView.contentInset = UIEdgeInsetsMake(_loginView.height-self.tableView.y, 0, 0, 0);
    
}
#pragma mark 更新UserInfo
-(void)updateUserInfoWithURL:(NSString*)url userName:(NSString*)name{
    
    UIImage *placeHolder = [UIImage scaleFromImage:[UIImage imageNamed:@"default_head"] toSize:CGSizeMake(60, 60)];
    if (!url) {
        [_userInfo setImage:placeHolder forState:UIControlStateNormal];
    }else{
        [_userInfo sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:placeHolder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_userInfo setImage:[image drawCircleImageWithImage:[UIImage scaleFromImage:image toSize:placeHolder.size] WithCornerRadius:placeHolder.size.width] forState:UIControlStateNormal];
        }];
    }
    [_userInfo setTitle:name forState:UIControlStateNormal];
    _userInfo.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    _userInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_userInfo setTitleEdgeInsets:UIEdgeInsetsMake(_userInfo.imageView.frame.size.height+15,-_userInfo.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [_userInfo setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -_userInfo.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}
#pragma mark - 登入按钮点击事件
-(void)loginButtonClick:(UIButton*)sender{
    
    switch (sender.tag) {
        case PDAPPLoginTypeWechat:{//微信登录
            [self loginWithWechat];
        }
            break;
        case PDAPPLoginTypeSina:{//新浪微博登录
            [self loginWithSina];
        }
            break;
        case PDAPPLoginTypeQQ:{//twitter登录
            [self loginWithQQ];
        }
            break;
        case PDAPPLoginTypeFacebook:{//facebook登录
            [self loginWithFacebook];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark 登出按钮点击事件
-(void)logoutButtonClick{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch ([defaults integerForKey:PD_APPLOGINBY]) {
        case PDAPPLoginTypeWechat://微信登出
            [self logoutWithWechat];
            break;
        case PDAPPLoginTypeSina://新浪微博登出
            [self logoutWithSina];
            break;
        case PDAPPLoginTypeQQ://twitter登出
            [self logoutWithQQ];
            break;
        case PDAPPLoginTypeFacebook://facebook登出
            [self logoutWithFacebook];
            break;
        default:
            break;
    }
}
#pragma mark 登入成功
-(void)loginSuccessful:(NSNotification*)notify{
    
    [self setupLogoutItem]; //添加logout按钮
    [self.loginView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.loginView removeFromSuperview];
    self.loginView = nil;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if (notify.userInfo) {
        NSDictionary *userInfo = notify.userInfo;
        [self updateUserInfoWithURL:[userInfo objectForKey:@"headimgurl"] userName:[userInfo objectForKey:@"nickname"]];
    }else{
        [self loadUserInfoData];//记载登录用户数据
    }
    
}
//上传登录用户信息
-(void)pullLoginUserInfoWithLoginType:(PDAPPLoginType)type userID:(NSString*)ID userName:(NSString*)name headeImagURL:(NSString*)URL{
    
    [[IMNetworkingTools sharedNetWorkingTools]loginSuccessfulWithLoginType:type userID:ID userName:name headeImagURL:URL CallBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return;
        }
        
        //        PD_NSLog(@"上传登录用户信息\n%@",response);
        
        IMModel *model = [IMModel mj_objectWithKeyValues:response];
        [self updateUserInfoWithURL:model.data.img userName:model.data.nickname];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:model.data.ID forKey:PD_APPUID];
        [defaults setObject:model.data.token forKey:PD_APPTOKEN];
        [defaults synchronize];
        
    }];
}
#pragma mark 登出成功
-(void)logoutSuccessful{
    
    [self setupLoginView];
    self.navigationItem.rightBarButtonItem = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:PDAPPLoginTypeIsLogout forKey:PD_APPLOGINBY];
    [defaults removeObjectForKey:PD_USERID];
    [defaults removeObjectForKey:PD_ACCESSTOKEN];
    [defaults removeObjectForKey:PD_REFRESHTOKEN];
    [defaults removeObjectForKey:PD_APPTOKEN];
    [defaults removeObjectForKey:PD_APPUID];
    [defaults synchronize];
    
    [self updateUserInfoWithURL:nil userName:@"用户名"];
}
#pragma mark - 登入方式
//新浪登入
- (void)loginWithSina{
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = SINAREDIRECTURL;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"PDMeController",
                         @"Other_Info_1": @"loginWithSina",};
    [WeiboSDK sendRequest:request];
    
}
//微信登入
- (void)loginWithWechat{
    
    SendAuthReq *request = [[SendAuthReq alloc]init];
    request.scope = @"snsapi_userinfo";
    request.state = @"People'sDailys";
    request.openID = WECHATAPPID;
    
    if ([WXApi sendReq:request]) {
        NSLog(@"成功成功");
    }else{
        NSLog(@"失败失败");
    }
    
//    //test
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setInteger:PDAPPLoginTypeWechat forKey:PD_APPLOGINBY];//记录app登入方式
//    [self loginSuccessful];

}

//Twitter登入
- (void)loginWithQQ{
    
    [IMQQService initQQService];

}
//facebook登入
- (void)loginWithFacebook{
    //test
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:PDAPPLoginTypeFacebook forKey:PD_APPLOGINBY];//记录app登入方式
    [self loginSuccessful:nil];

}
#pragma mark - 登出方式
//新浪登出
- (void)logoutWithSina{
    [WeiboSDK logOutWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:PD_ACCESSTOKEN] delegate:self withTag:@"SinaUser"];
    [self logoutSuccessful];

}
//微信登出
- (void)logoutWithWechat{
    
    [self logoutSuccessful];
}
//Twitter登出
- (void)logoutWithQQ{
    [self logoutSuccessful];
    [IMQQService logoutQQService];
}
//facebook登出
- (void)logoutWithFacebook{
    [self logoutSuccessful];
}

#pragma mark - WBHttpRequestDelegate代理方法
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    //    PD_NSLog(@"收到一个来自微博Http请求的网络返回=%@",result);
    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if(!err) {
        NSString *resultStr = [dic objectForKey:@"result"];
        if ([resultStr isEqualToString:@"true"]) {
            [[PDPublicTools sharedPublicTools] showMessage:@"Logout successful" duration:3];
            [self logoutSuccessful];
        }
    }
}
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    [[PDPublicTools sharedPublicTools] showMessage:@"Logout failed" duration:3];
    //    PD_NSLog(@"%@",error);
}
#pragma mark - UITableView代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [SVProgressHUD show];
    NSDictionary *dic = self.dataArr[indexPath.row];
    IMIndexController *indexVC = [[IMIndexController alloc]init];
    indexVC.url = [dic objectForKey:@"indexStr"];
    indexVC.title = [dic objectForKey:@"title"];
    [self.navigationController pushViewController:indexVC animated:YES];
    
}
@end
