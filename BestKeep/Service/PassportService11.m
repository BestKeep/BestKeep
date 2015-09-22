//
//  PassportService.m
//  MobileUU
//================================================================
//1.0改写用户详信息方法加上callback，用户获取到ST好TGT后立刻set   万黎君
//1.1用户基本信息解析userID                                   万黎君
//1.2新增注册方法                                            万黎君
//1.3改写方法                                               万黎君
//1.4增加用户统计                                            万黎君
//================================================================
//  Created by 王义杰 on 15/5/14.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "PassportService.h"
#import "InterfaceURLs.h"
#import "RequestFromServer.h"
#import "Result.h"
#import "Userinfo.h"
#import "MD5.h"
#import "Common.h"
#import "AppControlManager.h"
#import "CacheFile.h"
#import "ManagerSetting.h"
#import "LoginController.h"
#import "AppDelegate.h"
#import "UserInfoModel.h"
//#import "Inter"
//#import "ManagerSetting.h"
//#import "RealNameInfo.h"
//#import "IDCardsInfo.h"
@implementation PassportService

//获取ST
+ (void) getSTbyTGT:(NSString*)tgt url:(NSString*)url
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{

    
    NSString *surl = [strPassport stringByAppendingString:strst];
    
    NSString *strurl = [NSString stringWithFormat:@"%@/%@",surl,tgt];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:url,@"service", nil];
    
   
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary * headDic = [AppControlManager getSTHeadDictionary:dic strurl:strurl];
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }


    NSLog(@"\n--------------------->>> headParameters : %@\n", manager.requestSerializer.HTTPRequestHeaders);

    
    [manager POST:strurl parameters:dic
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              
              NSString *st = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
              
              NSDictionary *st_dic = [NSDictionary dictionaryWithObjectsAndKeys:st,@"st", nil];
              
              [Userinfo setST:st];
              
              
              //[CacheFile WriteToFile];
              success(operation, st_dic);
              
          }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
              
              //相应不等于200-299
              failure(operation,error);
              
          }];
}

//登录
+(void)login:(UIView *)view
            :(NSDictionary *) parameters
            :(MyCallback)callback
{
    Result *loginResult = [Result alloc];
    
    //判断本地缓存中是否有TGT，如果有则不调用登录接口，如果没有则调用登录接口
    if ([[Userinfo getUserTGT] isEqualToString:@""] || [Userinfo getUserTGT] == nil) {
        //接口地址
        NSString *strMissionList = [strPassport stringByAppendingString:strAccountLoginURL];
        
        NSDictionary *head_dic = [AppControlManager getSTHeadDictionary:parameters strurl:strMissionList];
        
        [RequestFromServer requestWithURL:strMissionList
                                     type:@"POST"
                    requsetHeadDictionary:head_dic
                    requestBodyDictionary:parameters
                              showHUDView:view
                       showErrorAlertView:YES
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      loginResult.success = [[responseObject objectForKey:@"success"] boolValue];
                                      
                                      loginResult.msg = [responseObject objectForKey:@"msg"];
                                      
                                      
                                      NSDictionary *tgtdic = [responseObject objectForKey:@"data"];
                                      
                                      NSString *strTGT = [tgtdic objectForKey:@"tgt"];
                                      
                                      [Userinfo setUserTGT:strTGT];
                                      
                                      if (loginResult.success) {
                                          [self getSTbyTGT:strTGT url:@"http://app.bestkeep" success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              
                                              
                                              loginResult.success = YES;
                                              
                                              NSDictionary *stObj = (NSDictionary *)responseObject;
                                              
                                              NSString *st = [stObj objectForKey:@"st"];
                                              
                                              [Userinfo setST:st];
                                              
                                              callback(loginResult);
                                              
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              
                                          }];
                                      }else{
                                          loginResult.success = NO;
                                          
                                          loginResult.msg = [responseObject objectForKey:@"msg"];
                                          
                                          if ([[responseObject objectForKey:@"code"]isKindOfClass:[NSString class]]) {
                                              
                                              loginResult.code = [responseObject objectForKey:@"code"];
                                              
                                          }else{
                                              
                                              loginResult.code = [[responseObject objectForKey:@"code"]stringValue ];
                                              
                                          }
                                          
                                          
                                          callback(loginResult);
                                          
                                      }
                                      
                                      loginResult.data = tgtdic;
                                      
                                    
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      
                                      NSLog(@"获取TGT失败了");
                                      //调用失败的方法在这里添加
                                  }];
    }else{
        //如果本地缓存中有TGT，则判断本地缓存中是否有ST，如果没有，取ST，如果有则直接登录
        
        if ([[Userinfo getST] isEqualToString:@"UTOUU-ST-INVALID"] || [Userinfo getST] == nil){
            
            [self getSTbyTGT:[Userinfo getUserTGT] url:@"http://bestkeep.utouu" success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *stObj = (NSDictionary *)responseObject;
                
                NSString *st = [stObj objectForKey:@"st"];
                
                [Userinfo setST:st];
                
                loginResult.success = true;
                
                loginResult.msg = @"登录成功";
                
                callback(loginResult);
                
                NSLog(@"重新获取ST");
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                loginResult.success = false;
                
                [Userinfo setUserTGT:@""];
                
                loginResult.msg = @"重新获取ST令牌失败,请再次尝试登录";
                
                callback(loginResult);
                
                NSLog(@"重新获取ST失败");
                
            }];
            
        }else{
            
            loginResult.success = true;
            
            loginResult.msg = @"登录成功";
            
            callback(loginResult);
        }
    }
    
}


//注销
+(void)logout{
    [Userinfo setLoginSatuts:@"0"];
    
    [Userinfo setST:@"UTOUU-ST-INVALID"];
    
    [Userinfo setUserTGT:@""];
    
    [Userinfo setPWD:@""];
    
    [Userinfo setUserid:@""];
    
    [Common saveUserImage:@""];
    
    [CacheFile WriteToFileWithDict:nil];
}


#pragma mark - 获取验证码
+(void)applyforVerifyCode:(MyCallback)callback{
    
    NSString *url = [strRegister stringByAppendingString:strSMSPic];
    
    NSString *uuid = [NSString stringWithFormat:@"%d",arc4random()];
    
    [ManagerSetting setVerifyCodeUUID:uuid];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         uuid,@"key",
                         @"3600",@"time",
                         @"3",@"source",//ios-p
                         //@"2",@"source",//ios
                         @"100",@"width",
                         @"40",@"height",
                         @"",@"sign",
                         @"4",@"len", nil];
    
    NSMutableDictionary *headDic = [AppControlManager getSTHeadDictionary:dic strurl:url];
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    
    NSLog(@"\n--------------------->>> headParameters : %@\n", manager.requestSerializer.HTTPRequestHeaders);
    [manager POST:url parameters:dic
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              callback(responseObject);
              
          }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
              
          }];
}

#pragma  mark - 注册
+(void)registerUserAccount:(UIViewController *)viewController
                          :(NSDictionary *) parameters
                          :(MyCallback)callback{

    NSString *url = [strPassport stringByAppendingString:strRegisterResult];
    NSDictionary * head_dic = [AppControlManager getSTHeadDictionary:parameters strurl:url];
    
    
    [RequestFromServer requestWithURL:url type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:parameters showHUDView:viewController.view showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Result *registerResult = [[Result alloc]init];
        
        NSString *success = [[responseObject objectForKey:@"success"]stringValue];
        
        NSString *message = [responseObject objectForKey:@"msg"];
        
        if ([success isEqualToString:@"1"]) {
            
            registerResult.success = YES;
            
            registerResult.msg = message;
            
        }else{
            
            registerResult.success = NO;
            
            registerResult.msg = message;
        }
        callback(registerResult);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+(void)getUserInfoWithHeadParams:(NSDictionary *)headDic bodyParams:(NSDictionary *)bodyParams callBack:(GetUjserInfoCallBack)callBack{
    
    NSString *strurl = [strUtouuAPI stringByAppendingString:struser_baseinfo];
    NSMutableDictionary *head_dicUB = [AppControlManager getSTHeadDictionary:nil strurl:strurl];
    
    [RequestFromServer requestWithURL:strurl type:@"POST" requsetHeadDictionary:head_dicUB requestBodyDictionary:bodyParams showHUDView:nil showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            NSDictionary * dict = [responseObject objectForKey:@"data"];
            NSString *msg = [responseObject objectForKey:@"msg"];
            if ([[responseObject objectForKey:@"success"] boolValue]) {
                [CacheFile WriteToFileWithDict:dict];
                UserInfoModel * userInfo = [[UserInfoModel alloc] initWithDictionary:dict];
                
                callBack(userInfo,nil);
                
            }else{
                NSError * error = [NSError errorWithDomain:msg code:[[dict objectForKey:@"code"] integerValue] userInfo:nil];
                callBack(nil,error);
            }
            
        }else{
            NSError * error = [NSError errorWithDomain:@"没有内容" code:111111 userInfo:nil];
            callBack(nil,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callBack(nil,error);
    }];
}



#pragma mark - 版本检测
+(void)checkOutVersionnext:(NSDictionary*)parameters
                          :(MyCallback)callback;//版本检测
{


        NSString *url = [strVersion stringByAppendingString:strCheck_version];
        NSDictionary *head_dic = [[NSMutableDictionary alloc]init];
        head_dic = [AppControlManager getSTHeadDictionary:parameters strurl:url];
    
        [RequestFromServer requestWithURL:url type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:parameters showHUDView:nil showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *result_dic = responseObject;
            NSString * success = [[result_dic objectForKey:@"success"] stringValue];
            Result *versionResult = [[Result alloc]init];
            if ([success isEqualToString:@"1"]) {
                versionResult.success = YES;
                
                versionResult.data = [result_dic objectForKey:@"data"];
                
                versionResult.msg = [result_dic objectForKey:@"msg"];
                
            }
            callback(versionResult);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }




@end
