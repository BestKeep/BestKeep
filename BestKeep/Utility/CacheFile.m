//
//  CacheFile.m
//  MobileUU
//=========================
//1.0 UDID写入缓存                  万黎君
//1.1 将TGT存入写到字典的最后         万黎君
//1.2讲USERID雪如缓存                万黎君
//=========================
//  Created by 王義傑 on 14-5-31.
//  Copyright (c) 2014年 Shanghai Pecker Network Technology Co., Ltd. All rights reserved.
//

#import "CacheFile.h"
#import "InterfaceURLs.h"
#import "Userinfo.h"

@implementation CacheFile

+(void) WriteToFileWithDict:(NSDictionary *)dict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"usercache.plist"];
    NSLog(@"%@",plistPath);
    NSFileManager * fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:plistPath]) {
        
    }else{
        [fm createFileAtPath:plistPath contents:nil attributes:nil];

    }
    
    NSString *st;
    if ([Userinfo getST]==nil) {
        st = @"";
    }else{
        st = [Userinfo getST];
    }
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [Userinfo getCellPhone],@"account",
                                 
                                 [Userinfo getLoginSatuts],@"loginstatus",
                                 st,@"st",
                                 [Userinfo getUserTGT],@"tgt",
                                 [Userinfo getVisitor_code],@"visitor_code",
                                 [Userinfo getUserid],@"userid",
                                 
                                 nil];
    
    for (NSString *key in dict.allKeys) {
        [data setObject:[dict objectForKey:key] forKey:key];
    }
    
    //写入文件
    
//    BOOL sucess = [fm createFileAtPath:plistPath contents:nil attributes:nil];
    
    BOOL sucess = [data writeToFile:plistPath atomically:YES];
    if (sucess) {
        NSLog(@"写入缓存成功");
    }else{
        NSLog(@"写入缓存失败");
    }
    NSLog(@"文件已存在:%@",data);

}


+(NSDictionary *)loadLocalUserFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"usercache.plist"];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        

        
        [Userinfo setLoginSatuts:[dictionary objectForKey:@"loginstatus"]];
        
        [Userinfo setUserTGT:[dictionary objectForKey:@"tgt"]];
        
        [Userinfo setPWD:[dictionary objectForKey:@"pwd"]];
        
        [Userinfo setCellPhone:[dictionary objectForKey:@"account"]];
        
        [Userinfo setST:[dictionary objectForKey:@"st"]];
        
        [Userinfo setVisitor_code:[dictionary objectForKey:@"visitor_code"]];
        
        [Userinfo setUserid:[dictionary objectForKey:@"userid"]];

        
        NSLog(@"读取data:%@",dictionary);
        return dictionary;
    }else{
        return nil;
    }
    
}


//+(BOOL)isOutDate{
//
//
//}


@end
