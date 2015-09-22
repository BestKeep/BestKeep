//
//  TwoViewController.m
//  BestKeep
//
//  Created by 魏鹏 on 15/8/18.
//  Copyright (c) 2015年 utouu. All rights reserved.
//

#import "TwoViewController.h"
#import "BKWebView.h"
#import "SBJson.h"
#import <WebKit/WebKit.h>
@interface TwoViewController ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property BKWebView     *webView;
@property (nonatomic,strong)WKWebView *webView1;
@property (nonatomic,strong)UIProgressView *progress;
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"U7";
    if (SysVer < 8.0 ) {
        self.webView = [[BKWebView alloc] initWithFrame:CGRectZero] ;
        [self.view addSubview:self.webView];
        self.webView.delegate = self;
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view. mas_left).offset(0);
            make.top.equalTo(self.view.mas_top).mas_offset(0);
            make.right.equalTo(self.view. mas_right).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).mas_offset(10);
         }];
        NSURL *url =[[NSURL alloc]initWithString:@"http://m.bestkeep.cn/u7"];
        NSURLRequest *request =[[NSURLRequest alloc]initWithURL:url];
        [self.webView loadRequest:request];
    }else{

    _webView1 = [[WKWebView alloc]initWithFrame:CGRectZero];
    _webView1.UIDelegate=self;
    _webView1.navigationDelegate =self;
    [self.view addSubview:_webView1];
    [_webView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).mas_offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(10);
    }];
    _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 2)];
    [self.view addSubview:_progress];
    [_webView1 addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [_webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.bestkeep.cn/u7"]]];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    if (SysVer < 8.0) {
        NSURL *url =[[NSURL alloc]initWithString:@"http://m.bestkeep.cn/u7"];
        NSURLRequest *request =[[NSURLRequest alloc]initWithURL:url];
        [self.webView loadRequest:request];
        
    }else{
        [_progress setProgress:0.0f animated:true];
        [_webView1 addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.bestkeep.cn/u7"]]];
    }

}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    //html加载完后触发
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_progress setProgress:0.0 animated:false];

}
#pragma mark -加载条
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"]&&object==_webView1) {
        [_progress setAlpha:1.0f];
        [_progress setProgress:_webView1.estimatedProgress animated:YES];
        if (_webView1.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [_progress setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [_progress setProgress:0.0f animated:NO];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
