//
//  OneViewController.h
//  BestKeep
//
//  Created by 魏鹏 on 15/8/18.
//  Copyright (c) 2015年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OneAnotherController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface OneViewController : BaseViewController<UIWebViewDelegate>{
    UIWebView *_webView;

}

@property (nonatomic,strong)NSString *oneUrl;
@property (nonatomic,strong)NSString *oneRequest;
@property (nonatomic,strong)NSString *myTitle;
@property (nonatomic,strong)NSString *hasShop;
@property (nonatomic,strong)NSString *url_strings;
@end
