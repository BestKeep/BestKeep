//
//  OneAnotherController.h
//  BESTKEEP
//
//  Created by cunny on 15/8/30.
//  Copyright (c) 2015年 YISHANG. All rights reserved.
//

#import "BaseViewController.h"
#import "OneViewController.h"
@interface OneAnotherController : BaseViewController<UIWebViewDelegate>{
    UIWebView *_webView;
}
@property (nonatomic,strong)NSString *oneAnotherUrl;
@property (nonatomic,strong)NSString *oneAnotherRequest;
@property (nonatomic,strong)NSString *myTitle;
@property (nonatomic,strong)NSString *hasShop;
@end
