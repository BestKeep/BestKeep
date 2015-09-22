//
//  OneViewController.m
//  BestKeep
//
//  Created by 魏鹏 on 15/8/18.
//  Copyright (c) 2015年 utouu. All rights reserved.
//

#import "OneViewController.h"
#import "BKWebView.h"
#import "AppDelegate.h"
#import "CacheFile.h"
#import "SBJson.h"
#import "PassportService.h"
#import "ManagerSetting.h"
#import "UMSocial.h"
#import "BKService.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "ConfirmationIndentViewController.h"
#import "Result.h"
#import "Userinfo.h"
#import "HomeViewController.h"
#import <WebKit/WebKit.h>


@interface OneViewController ()<UMSocialUIDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>{
    UIImageView *imageView;
    BOOL end;
    NSString *ispop;
}
@property  (nonatomic, strong)UIWebView *webView;
@property (nonatomic,strong)NSString *isUrl;
@property (nonatomic,strong) NSString *invit;
@property (nonatomic) BOOL isLogin;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) NSMutableArray *url_Array;
@property (nonatomic,strong)WKWebView *webView1;
@property (nonatomic,strong)UIProgressView *progressView;
@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AFHTTPRequestOperationManager manager].operationQueue cancelAllOperations];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    //    UserInfoModel *Model = app.userInfo;
    self.invit = [Userinfo getVisitor_code];
    self.isLogin = app.isLogin;
    if (self.myTitle == nil || [self.myTitle isEqualToString:@""]) {
        self.myTitle =@"首页";
        [self checkVersion];
    }
    self.title = self.myTitle;
    //[CacheFile loadLocalUserFile];
    if (self.oneRequest == nil ||[self.oneRequest isEqualToString:@""]) {
        self.oneRequest = strIndexhtml;
        [self setNavBarImage];
    }else{
        self.title = self.myTitle;
    }
    if (SysVer >= 8.0) {
        [self loadWebView1];
    }
    else{
        [self loadWebView2];
    }
       if ([self.hasShop isEqualToString:@"has"]) {
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButton.frame = CGRectMake(0, 0, 25, 25);
        
        [self.leftButton setImage:[UIImage imageNamed:@"iconfont-cartfill"] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
        [self.leftButton addTarget:self action:@selector(gotoShop) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([self.myTitle isEqualToString:@"收银台"]) {
        ispop = @"1";
    }else if ([self.myTitle isEqualToString:@"收银台 "]){
        ispop = @"2";
    }else if ([self.myTitle isEqualToString:@" 收银台"]){
        ispop = @"3";
    }
}

#pragma mark - ios8加载网页方法
-(void)loadWebView1{
    _webView1 = [[WKWebView alloc]initWithFrame:CGRectZero];
    _webView1.UIDelegate =self;
    _webView1.navigationDelegate=self;
    
    [self.view addSubview:_webView1];
    [_webView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).mas_offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(0);
    }];
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 2)];
    [self.view addSubview:_progressView];
    [_webView1 addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    [_webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.oneRequest]]];
}
#pragma mark - ios7加载网页方法
-(void)loadWebView2{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero] ;
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view. mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).mas_offset(0);
        make.right.equalTo(self.view. mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(0);
         }];
    NSURL *url =[[NSURL alloc]initWithString:self.oneRequest];
    NSURLRequest *request =[[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:request];
}

-(void)setNavBarImage{
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 40.0f)];//初始化图片视图控件
    imageView.contentMode = UIViewContentModeScaleAspectFit;//设置内容样式,通过保持长宽比缩放内容适应视图的大小,任何剩余的区域的视图的界限是透明的。
    UIImage *image = [UIImage imageNamed:@"NavImage.png"];//初始化图像视图
    [imageView setImage:image];
    self.navigationItem.titleView = imageView;//设置导航栏的titleView为imageView
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //self.webView.scrollView.scrollEnabled  = NO;
    //[_webView loadHTMLString: @"" baseURL: nil];
    if (self.myTitle == nil || [self.myTitle isEqualToString:@""]) {
        self.myTitle =@"首页";
        NSURL *url =[[NSURL alloc]initWithString:self.oneRequest];
        NSURLRequest *request =[[NSURLRequest alloc]initWithURL:url];
        [_webView1 loadRequest:request];

    }
}

-(void)gotoShop{
  
    if (self.isLogin) {
        BuyCarViewController *bvc =[[BuyCarViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bvc animated:YES];
        
    }else{
        LoginController *loginVC = [[LoginController alloc]init];
        BKNavigationController *nv = [[BKNavigationController  alloc] initWithRootViewController:loginVC];
        [self presentViewController:nv animated:YES completion:nil];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    //html加载完后触发

    if (self.oneUrl ==nil || [self.oneUrl isEqualToString:@""]) {
        [self.webView stringByEvaluatingJavaScriptFromString: @"OBJC.executeJs(\"init\",\"{}\")"];
    }else{
        [self.webView stringByEvaluatingJavaScriptFromString: self.oneUrl];

    }
   
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
        self.webView.scrollView.scrollEnabled  = NO;
   
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
 
    NSString *requestString = [[request URL]absoluteString];//获取请求的绝对路径.
    requestString =  [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *header =@"http://objc/";

    if ([requestString rangeOfString:header].location != NSNotFound)
    {
        BOOL shops = NO;
        NSArray *components = [requestString componentsSeparatedByString:@"http://objc/"];
        if ([components count] >1 ) {
            NSUInteger range = [requestString rangeOfString:@"{"].location;
            NSString *b = [requestString substringFromIndex:range];
            NSDictionary *param_dic  = [b JSONValue];
            NSArray *widget = [param_dic objectForKey:@"widget"];
            if ([widget containsObject:@"shopcarbtn"] ) {
                shops = YES;
              
            }
            if ([[param_dic objectForKey:@"action"] isEqualToString:@"open"]) {
                NSString * number =  [param_dic objectForKey:@"target"];
                //分享
                if ([number isEqualToString:@"share"]) {
                    //设置友盟社会化组件appkey
                     NSDictionary *dic = [param_dic objectForKey:@"parameters"];
                    NSString *goodsName = [dic objectForKey:@"goodsName"];
                    // NSString *goodsNo = [dic objectForKey:@"goodsNo"];
                    NSString *imageUrl = [dic objectForKey:@"imageUrl"];
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                    [UIImage imageWithData:imageData];
                    NSString *shareTitle = [dic objectForKey:@"shareTitle"];
                    //NSString *marketPrice = [dic objectForKey:@"marketPrice"];
                    //NSString *memberPrice = [dic objectForKey:@"memberPrice"];
                    NSString *shareContent = [dic objectForKey:@"shareContent"];
                    //NSString *shareWBContent = [dic objectForKey:@"shareWBContent"];
                    NSString *shareUrl = [dic objectForKey:@"shareUrl"];
                    if (self.invit == nil || !self.isLogin) {
                        LoginController *loginVC = [[LoginController alloc]init];
                        BKNavigationController *nv = [[BKNavigationController  alloc] initWithRootViewController:loginVC];
                        [self presentViewController:nv animated:YES completion:nil];
                    }else{
                        
                        NSString *shares = [shareUrl stringByReplacingOccurrencesOfString:@"{code}" withString:self.invit];
                        UIImage *images = [UIImage imageWithData:imageData];
                        //微信和朋友圈
                        //                  1WRI360206
                        NSString *com = shares;
                        [UMSocialData setAppKey:@"55d42806e0f55a92f0003530"];
                        //    //设置支持没有客户端情况下使用SSO授权
                        [UMSocialQQHandler setSupportWebView:YES];
                        [UMSocialWechatHandler setWXAppId:@"wx12ade979ef648797" appSecret:@"f9b523512927f15249dad73161d21934" url:com];
                        //qq空间和qq好友
                        [UMSocialQQHandler setQQWithAppId:@"1104759459" appKey:@"ymbLBKw0coxYre0r" url:com];
                        [self shareVideo:images title:shareTitle content:shareContent];
                    
                    }

                   
                    
                }else if([number isEqualToString:@"buy"]){
                    NSDictionary *dic = [param_dic objectForKey:@"parameters"];
                    NSString *goods_id = [dic objectForKey:@"goods_id"];
                    NSString *amount = [dic objectForKey:@"amount"];
                    NSString *goods_pro_rel1 = [dic objectForKey:@"goods_pro_rel1"];
                    NSString *goods_pro_rel2 = [dic objectForKey:@"goods_pro_rel2"];
                    NSString *goods_pro_rel3 = [dic objectForKey:@"goods_pro_rel3"];
                    NSString *goods_pro_rel4 = [dic objectForKey:@"goods_pro_rel4"];
                    NSString *goods_pro_rel5 = [dic objectForKey:@"goods_pro_rel5"];
                    NSString *goods_reserve_id = [dic objectForKey:@"goods_reserve_id"];
                    NSMutableDictionary *buy_dic = [[NSMutableDictionary alloc]init];
                    NSMutableArray *array = [NSMutableArray new];
                    [buy_dic setObject:goods_id forKey:@"goods_id"];
                    [buy_dic setObject:amount forKey:@"amount"];
                    [buy_dic setObject:goods_pro_rel1 forKey:@"goods_pro_rel1"];
                    [buy_dic setObject:goods_pro_rel2 forKey:@"goods_pro_rel2"];
                    [buy_dic setObject:goods_pro_rel3 forKey:@"goods_pro_rel3"];
                    [buy_dic setObject:goods_pro_rel4 forKey:@"goods_pro_rel4"];
                    [buy_dic setObject:goods_pro_rel5 forKey:@"goods_pro_rel5"];
                    [buy_dic setObject:goods_reserve_id forKey:@"goods_reserve_id"];
                    [array addObject:buy_dic];
                    if (self.isLogin) {
                        ConfirmationIndentViewController *cVC =[[ConfirmationIndentViewController alloc]init];
                        cVC.sc_array = array;
                        cVC.formDetail = @"1";
                        [self.navigationController pushViewController:cVC animated:YES];
                    }else{
                        LoginController *loginVC = [[LoginController alloc]init];
                        BKNavigationController *nv = [[BKNavigationController  alloc] initWithRootViewController:loginVC];
                        [self presentViewController:nv animated:YES completion:nil];
                    }
                    
                }else{

                    if ([number isEqualToString:@""] || number == nil) {
                        number = @"";
                    }
                    NSDictionary *dic = [param_dic objectForKey:@"parameters"];
                    if (dic == nil) {
                        self.isUrl =@"";
                    }else{
                        NSString *jsonString = [Common dictionaryToJson:dic];
                
                        NSString *strUrl = [NSString stringWithFormat:@"OBJC.executeJs(\"init\",%@)",jsonString];
                        self.isUrl = strUrl;
                    
                    }
                   
                    OneAnotherController *aVC = [[OneAnotherController alloc]init];
                   
                    aVC.myTitle = [dic objectForKey:@"title"];
                    aVC.oneAnotherUrl = self.isUrl;
                    aVC.oneAnotherRequest = number;
                    if (shops) {
                        aVC.hasShop = @"has";
                        
                    }

                    [self.navigationController pushViewController:aVC animated:NO];

                    return YES;
                }
            }else if ([[param_dic objectForKey:@"action"] isEqualToString:@"message"]){
                NSString * number =  [param_dic objectForKey:@"target"];
                if (self.isLogin) {
                    

                if ([number isEqualToString:@"collect/add"]) {
                    NSDictionary *dic = [param_dic objectForKey:@"parameters"];
                    NSString *goods_id = [dic objectForKey:@"goodsId"];
                    NSString *randomKey = [param_dic objectForKey:@"randomKey"];
                    [BKService addGoodsToCollect:goods_id view:nil callback:^(id obj) {
                        Result *collect_result = obj;
                        self.url_Array = (NSMutableArray*)collect_result.data;
                        NSDictionary *dic = (NSDictionary *)collect_result.data;
                        NSString *jsonString = [Common dictionaryToJson:dic];
                        NSString *strUrl = [NSString stringWithFormat:@"OBJC.executeJs(%@,%@)",randomKey,jsonString];
                        if (collect_result.data!=nil) {
                            [self.webView stringByEvaluatingJavaScriptFromString: strUrl];

                            }
                        }];
                }else if ([number isEqualToString:@"collect/delete"]){
                    NSDictionary *dic = [param_dic objectForKey:@"parameters"];
                    NSString *goods_id = [dic objectForKey:@"goodsId"];
                    NSString *randomKey = [param_dic objectForKey:@"randomKey"];
                    [BKService deleteCollectGoods:goods_id view:nil callback:^(id obj) {
                        Result *collect_result = obj;
                        NSDictionary *dic = (NSDictionary *)collect_result.data;
                        NSString *jsonString = [Common dictionaryToJson:dic];
                        NSString *strUrl = [NSString stringWithFormat:@"OBJC.executeJs(%@,%@)",randomKey,jsonString];
                        if (collect_result.data!=nil) {
                            [self.webView stringByEvaluatingJavaScriptFromString: strUrl];
                            
                        }
                    }];

                }else if ([number isEqualToString:@"shopping-cart/add"]){
                    NSMutableDictionary *dic = [param_dic objectForKey:@"parameters"];
                    [dic removeObjectForKey:@"goods_reserve_id"];
                    NSString *randomKey = [param_dic objectForKey:@"randomKey"];
                    NSString *strjson = [Common dictionaryToJson:dic];
                    [BKService addProduciontoShoppingCar:strjson view:self.view callback:^(id obj) {
                        
                        Result *add_result = obj;
                        NSDictionary *dic = (NSDictionary *)add_result.data;
                        NSString *jsonString = [Common dictionaryToJson:dic];
                        NSString *strUrl = [NSString stringWithFormat:@"OBJC.executeJs(%@,%@)",randomKey,jsonString];
                        if (add_result.data!=nil) {
                            [self.webView stringByEvaluatingJavaScriptFromString: strUrl];
                            
                        }
                     }];
                 }
            }
                else{
                    LoginController *loginVC = [[LoginController alloc]init];
                    BKNavigationController *nv = [[BKNavigationController  alloc] initWithRootViewController:loginVC];
                    [self presentViewController:nv animated:NO completion:nil];
                    
                }

            }else if ([[param_dic objectForKey:@"action"] isEqualToString:@"close"]){
                if ([ispop isEqualToString:@"1"]) {
                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                }else if ([ispop isEqualToString:@"2"]){
                    [self.navigationController popViewControllerAnimated:YES];
                }else if ([ispop isEqualToString:@"3"]){
                     [self.navigationController popToRootViewControllerAnimated:YES];
                   
                }
            }
            return YES;
        }
    }
    return YES;
    
}
//wkwebview == webview didFinishLoad
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
     [_progressView setProgress:0.0 animated:false];
    //[self setNavBarImage];

        if (self.oneUrl ==nil || [self.oneUrl isEqualToString:@""]) {
           
            [_webView1 evaluateJavaScript:@"OBJC.executeJs(\"init\",\"{}\")" completionHandler:nil];

        }else{
           [_webView1 evaluateJavaScript:self.oneUrl completionHandler:nil];
 
            
        }
}

//等同于 = webview shouldStartLoadWithRequest:navigation
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
   
    NSString *requestString =[navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *header =@"http://objc/";
    
        if ([requestString rangeOfString:header].location != NSNotFound)
        {
            BOOL shops = NO;
            NSArray *components = [requestString componentsSeparatedByString:@"http://objc/"];
            if ([components count] >1 ) {
                NSUInteger range = [requestString rangeOfString:@"{"].location;
                NSString *b = [requestString substringFromIndex:range];
                NSDictionary *param_dic  = [b JSONValue];
                NSArray *widget = [param_dic objectForKey:@"widget"];
                if ([widget containsObject:@"shopcarbtn"] ) {
                    shops = YES;
    
                }
                if ([[param_dic objectForKey:@"action"] isEqualToString:@"open"]) {
                    NSString * number =  [param_dic objectForKey:@"target"];
                    //分享
                    if ([number isEqualToString:@"share"]) {
                        //设置友盟社会化组件appkey
                         NSDictionary *dic = [param_dic objectForKey:@"parameters"];
                        NSString *goodsName = [dic objectForKey:@"goodsName"];
                        // NSString *goodsNo = [dic objectForKey:@"goodsNo"];
                        NSString *imageUrl = [dic objectForKey:@"imageUrl"];
    
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                        [UIImage imageWithData:imageData];
                        NSString *shareTitle = [dic objectForKey:@"shareTitle"];
                        //NSString *marketPrice = [dic objectForKey:@"marketPrice"];
                        //NSString *memberPrice = [dic objectForKey:@"memberPrice"];
                        NSString *shareContent = [dic objectForKey:@"shareContent"];
                        //NSString *shareWBContent = [dic objectForKey:@"shareWBContent"];
                        NSString *shareUrl = [dic objectForKey:@"shareUrl"];
                        if (self.invit == nil || !self.isLogin) {
                            LoginController *loginVC = [[LoginController alloc]init];
                            BKNavigationController *nv = [[BKNavigationController  alloc] initWithRootViewController:loginVC];
                            [self presentViewController:nv animated:YES completion:nil];
                        }else{
    
                            NSString *shares = [shareUrl stringByReplacingOccurrencesOfString:@"{code}" withString:self.invit];
                            UIImage *images = [UIImage imageWithData:imageData];
                            //微信和朋友圈
                            //                  1WRI360206
                            NSString *com = shares;
                            [UMSocialData setAppKey:@"55d42806e0f55a92f0003530"];
                            //    //设置支持没有客户端情况下使用SSO授权
                            [UMSocialQQHandler setSupportWebView:YES];
                            [UMSocialWechatHandler setWXAppId:@"wx12ade979ef648797" appSecret:@"f9b523512927f15249dad73161d21934" url:com];
                            //qq空间和qq好友
                            [UMSocialQQHandler setQQWithAppId:@"1104759459" appKey:@"ymbLBKw0coxYre0r" url:com];
                            [self shareVideo:images title:shareTitle content:shareContent];
                        
    
                        }
    
    
    
                    }else if([number isEqualToString:@"buy"]){
                        NSDictionary *dic = [param_dic objectForKey:@"parameters"];
                        NSString *goods_id = [dic objectForKey:@"goods_id"];
                        NSString *amount = [dic objectForKey:@"amount"];
                        NSString *goods_pro_rel1 = [dic objectForKey:@"goods_pro_rel1"];
                        NSString *goods_pro_rel2 = [dic objectForKey:@"goods_pro_rel2"];
                        NSString *goods_pro_rel3 = [dic objectForKey:@"goods_pro_rel3"];
                        NSString *goods_pro_rel4 = [dic objectForKey:@"goods_pro_rel4"];
                        NSString *goods_pro_rel5 = [dic objectForKey:@"goods_pro_rel5"];
                        NSString *goods_reserve_id = [dic objectForKey:@"goods_reserve_id"];
                        NSMutableDictionary *buy_dic = [[NSMutableDictionary alloc]init];
                        NSMutableArray *array = [NSMutableArray new];
                        [buy_dic setObject:goods_id forKey:@"goods_id"];
                        [buy_dic setObject:amount forKey:@"amount"];
                        [buy_dic setObject:goods_pro_rel1 forKey:@"goods_pro_rel1"];
                        [buy_dic setObject:goods_pro_rel2 forKey:@"goods_pro_rel2"];
                        [buy_dic setObject:goods_pro_rel3 forKey:@"goods_pro_rel3"];
                        [buy_dic setObject:goods_pro_rel4 forKey:@"goods_pro_rel4"];
                        [buy_dic setObject:goods_pro_rel5 forKey:@"goods_pro_rel5"];
                        [buy_dic setObject:goods_reserve_id forKey:@"goods_reserve_id"];
                        [array addObject:buy_dic];
                        if (self.isLogin) {
                            ConfirmationIndentViewController *cVC =[[ConfirmationIndentViewController alloc]init];
                            cVC.sc_array = array;
                            cVC.formDetail = @"1";
                            [self.navigationController pushViewController:cVC animated:YES];
                        }else{
                            LoginController *loginVC = [[LoginController alloc]init];
                            BKNavigationController *nv = [[BKNavigationController  alloc] initWithRootViewController:loginVC];
                            [self presentViewController:nv animated:YES completion:nil];
                        }
    
                    }else{
    
                        if ([number isEqualToString:@""] || number == nil) {
                            number = @"";
                        }
                        NSDictionary *dic = [param_dic objectForKey:@"parameters"];
                        if (dic == nil) {
                            self.isUrl =@"";
                        }else{
                            NSString *jsonString = [Common dictionaryToJson:dic];
    
                            NSString *strUrl = [NSString stringWithFormat:@"OBJC.executeJs(\"init\",%@)",jsonString];
                            self.isUrl = strUrl;
    
                        }
    
                        OneAnotherController *aVC = [[OneAnotherController alloc]init];
    
                        aVC.myTitle = [dic objectForKey:@"title"];
                        aVC.oneAnotherUrl = self.isUrl;
                        aVC.oneAnotherRequest = number;
                        if (shops) {
                            aVC.hasShop = @"has";
    
                        }
    
                        [self.navigationController pushViewController:aVC animated:NO];
    
                       
                    }
                }else if ([[param_dic objectForKey:@"action"] isEqualToString:@"message"]){
                    NSString * number =  [param_dic objectForKey:@"target"];
                    if (self.isLogin) {
    
    
                    if ([number isEqualToString:@"collect/add"]) {
                        NSDictionary *dic = [param_dic objectForKey:@"parameters"];
                        NSString *goods_id = [dic objectForKey:@"goodsId"];
                        NSString *randomKey = [param_dic objectForKey:@"randomKey"];
                        [BKService addGoodsToCollect:goods_id view:nil callback:^(id obj) {
                            Result *collect_result = obj;
                            self.url_Array = (NSMutableArray*)collect_result.data;
                            NSDictionary *dic = (NSDictionary *)collect_result.data;
                            NSString *jsonString = [Common dictionaryToJson:dic];
                            NSString *strUrl = [NSString stringWithFormat:@"OBJC.executeJs(%@,%@)",randomKey,jsonString];
                            if (collect_result.data!=nil) {
                                [_webView1 evaluateJavaScript:strUrl completionHandler:nil];
                                //[self.webView stringByEvaluatingJavaScriptFromString: strUrl];
    
                                }
                            }];
                    }else if ([number isEqualToString:@"collect/delete"]){
                        NSDictionary *dic = [param_dic objectForKey:@"parameters"];
                        NSString *goods_id = [dic objectForKey:@"goodsId"];
                        NSString *randomKey = [param_dic objectForKey:@"randomKey"];
                        [BKService deleteCollectGoods:goods_id view:nil callback:^(id obj) {
                            Result *collect_result = obj;
                            NSDictionary *dic = (NSDictionary *)collect_result.data;
                            NSString *jsonString = [Common dictionaryToJson:dic];
                            NSString *strUrl = [NSString stringWithFormat:@"OBJC.executeJs(%@,%@)",randomKey,jsonString];
                            if (collect_result.data!=nil) {
                                [_webView1 evaluateJavaScript:strUrl completionHandler:nil];
                                //[self.webView stringByEvaluatingJavaScriptFromString: strUrl];
    
                            }
                        }];
    
                    }else if ([number isEqualToString:@"shopping-cart/add"]){
                        NSMutableDictionary *dic = [param_dic objectForKey:@"parameters"];
                        [dic removeObjectForKey:@"goods_reserve_id"];
                        NSString *randomKey = [param_dic objectForKey:@"randomKey"];
                        NSString *strjson = [Common dictionaryToJson:dic];
                        [BKService addProduciontoShoppingCar:strjson view:self.view callback:^(id obj) {
    
                            Result *add_result = obj;
                            NSDictionary *dic = (NSDictionary *)add_result.data;
                            NSString *jsonString = [Common dictionaryToJson:dic];
                            NSString *strUrl = [NSString stringWithFormat:@"OBJC.executeJs(%@,%@)",randomKey,jsonString];
                            if (add_result.data!=nil) {
                                 [_webView1 evaluateJavaScript:strUrl completionHandler:nil];
                               // [_webView1 stringByEvaluatingJavaScriptFromString: strUrl];
    
                            }
                         }];
                     }
                }
                    else{
                        LoginController *loginVC = [[LoginController alloc]init];
                        BKNavigationController *nv = [[BKNavigationController  alloc] initWithRootViewController:loginVC];
                        [self presentViewController:nv animated:NO completion:nil];
                        
                    }
    
                }else if ([[param_dic objectForKey:@"action"] isEqualToString:@"close"]){
                    if ([ispop isEqualToString:@"1"]) {
                    
                         [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                    }else if ([ispop isEqualToString:@"2"]){
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }else if ([ispop isEqualToString:@"3"]){
                         [self.navigationController popToRootViewControllerAnimated:YES];
                       
                    }
                }
            }
        }
    decisionHandler(WKNavigationActionPolicyAllow);
}
//#pragma mark _分享
-(void)shareVideo:(UIImage *)image title:(NSString *)titles content:(NSString *)content{
    NSString *title = titles;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"53fbf399fd98c5a48f01c81f"
                                      shareText:title
                                     shareImage:image shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ, nil]
                                       delegate:nil];
}


-(void)checkVersion{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app.isLogin) {
        
        NSString *app_Version = [Common getAppVersion];
        NSDictionary *param_dic = [NSDictionary dictionaryWithObjectsAndKeys:app_Version,@"version", nil];
        
        [PassportService checkOutVersionnext:param_dic :^(id obj) {
            
            Result * version_result  = [[Result alloc]init];
            
            version_result = (Result *)obj;
            
            if (version_result.success) {
                
                NSMutableDictionary *result_dic = (NSMutableDictionary *)version_result.data;
                
                //  NSDictionary *data_dic = [result_dic objectForKey:@"data"];
                NSString *isupdate = [[result_dic objectForKey:@"upgrade"] stringValue];
                [ManagerSetting setversionUrl:[result_dic objectForKey:@"url"]];
                if ([isupdate isEqualToString:@"1"]) {
                    BOOL isforce = [[result_dic objectForKey:@"force"] boolValue];
                    NSString *message = [result_dic objectForKey:@"upgrade_msg"];
                    if (isforce) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        
                        alertView.delegate = self;
                        alertView.tag = 100;
                        [alertView show];
                    }
                    else{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        
                        alertView.tag = 200;
                        alertView.delegate = self;
                        [alertView show];
                    }
                }else{
                    
                    //                    [Common AlertViewTitle:@"提示" message:@"您当前已经是最新版本了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                }
                
            }
            
        }];
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[ManagerSetting getversionUrl]]];
        
        exit(0);
    }else if(alertView.tag == 200){
        
        switch (buttonIndex) {
            case 0:
                //   [[NSNotificationCenter defaultCenter]removeObserver:self];
                return;
                break;
            case 1:{
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[ManagerSetting getversionUrl]]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[ManagerSetting getversionUrl]]];
                    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
                    exit(0);
                }
                break;
            default:
                break;
            }
        }
    }
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess){
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
    
    [UMSocialData openLog:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.webView = nil;
    self.webView.delegate = nil;
    imageView = nil;
    if ([self.view window] == nil) {
        self.view = nil;
    }
}
#pragma mark -加载条
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"]&&object==_webView1) {
        [_progressView setAlpha:1.0f];
        [_progressView setProgress:_webView1.estimatedProgress animated:YES];
        if (_webView1.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [_progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [_progressView setProgress:0.0f animated:NO];
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc {
    [_webView1 removeObserver:self forKeyPath:@"estimatedProgress"];
    
    // if you have set either WKWebView delegate also set these to nil here
    [_webView1 setNavigationDelegate:nil];
    [_webView1 setUIDelegate:nil];
}
@end
