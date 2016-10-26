//
//  AppDelegate.m
//  im
//
//  Created by 邓云方 on 15/10/10.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize xmppStream;
@synthesize password;

- (void)setupStream
{
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (BOOL)connect
{
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    NSString *myJID =@"dyf11@127.0.0.1";
    NSString *myPassword = @"dyf11";
    // If you don't want to use the Settings view to set the JID,
    // uncomment the section below to hard code a JID and password.
    // myJID = @"user@gmail.com/xmppframework";
    // myPassword = @"";
    if (myJID == nil || myPassword == nil) {
        return NO;
    }
    [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    password = myPassword;
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
  
        return NO;
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    NSString * rect=NSStringFromCGRect([UIScreen mainScreen].bounds);
    NSLog(@"%@",rect);
    //self.window.backgroundColor=[UIColor blueColor];
    ViewController * view=[[ViewController alloc]init];
    self.window.rootViewController=view;
    [self setupStream];
    
    [self connect];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接成功！");
    NSError *error = nil;
    
    if (![xmppStream authenticateWithPassword:password error:&error])
    {
        NSLog(@"Error authenticating: %@", error);
    }
}
//认证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"认证成功");
    [self goOnline];
}

//认证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
 NSLog(@"认证  failed");
}

- (void)goOnline
{
    //创建一个在线对象
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    //发在线信息
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [[self xmppStream] sendElement:presence];
}
-
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"message %@",message);
    [message fromStr];//发送者
    XMPPJID * jid=[message from];
    [jid user];
    //创建通知
    NSNotification * note=[[NSNotification alloc]initWithName:@"come" object:@"hahha" userInfo:nil];
    //发到通知中心
    [[NSNotificationCenter defaultCenter] postNotification:note];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commas:) name:@"come" object:nil];
    /*
    NSDate * datee=[self getdelaystamptime:message]
    if()datee==nil
    {
        datee=[NSDate datee];// 本地
    }
    //离线消息
    NSDateFormatter * date=[[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * strDate=[date stringFromDate:datee]
    
    NSLog(@"%@",strdate)*/
}


- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"断开连接%@",error);
}
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
 
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  
}

@end
