//
//  AppDelegate.m
//  微信
//
//  Created by 邓云方 on 15/10/11.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MessageTableViewController.h"
@interface AppDelegate ()


{
LoginViewController * loginview;
    
}
@end

@implementation AppDelegate
@synthesize xmppStream,password,username;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    loginview=[[LoginViewController alloc]init];
    self.window.rootViewController=loginview;
    [self.window makeKeyAndVisible];
    //网络判定及加载数据
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status= [reach currentReachabilityStatus];
    
    if(status==NotReachable)
    {
        [DYFUtil alertWithMessage:@"无可用网络，请检查网络连接"];
        return NO;
    }
    else
    {
        
    }
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path=[paths objectAtIndex:0];
    path=[path stringByAppendingPathComponent:@"db.db"];
    NSLog(@"%@",path);
    self.db=[FMDatabase databaseWithPath:path];
    [self.db open];
    NSString * sql=@"create table if not exists messages(username text,date text ,time text,msg text,flag int,me text)";
    BOOL b=[self.db executeUpdate:sql];
    if(!b)
    {
        NSLog(@"创建数据表失败");
    }
    sql=@"create table if not exists friends(username text)";
    b=[self.db executeUpdate:sql];
    if(!b)
    {
        NSLog(@"创建数据表失败");
    }

    [self setupStream];
    return YES;
}
- (void)setupStream
{
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
//登录
- (BOOL)connectWithUserName:(NSString * )_uname andPassword:(NSString*)_upass
{
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    NSString *myJID =[NSString stringWithFormat:@"%@@115.159.1.248",_uname] ;
    NSString *myPassword =_upass;

    if (myJID == nil || myPassword == nil) {
        return NO;
    }
    [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    password = myPassword;
    username=_uname;
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        [DYFUtil alertWithMessage:@"See console for error details"];
        return NO;
    }
    return YES;
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接成功！");
    NSError *error = nil;
    //认证
    if(self.isRegist==NO)
    {
     if (![xmppStream authenticateWithPassword:password error:&error])
     {
        NSLog(@"Error authenticating: %@", error);
     }
    }
    else
    {
      if(![xmppStream registerWithPassword:password error:&error])
      {
          NSLog(@"Error register: %@", error);
          [DYFUtil alertWithMessage:@"连接服务器失败，请稍后再试"];
      }
    }
}
//认证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"认证成功");
    [SVProgressHUD dismiss];
    [self goOnline];
    [DYFUtil setUserPassword:password];
    [DYFUtil setUserName:username];
    //显示聊天主界面
    [loginview showMainView];


}

//认证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"认证  failed");
     [SVProgressHUD
      showErrorWithStatus:@"请检查账户和密码" duration:1.0];
    [xmppStream disconnect];

}
// 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
     NSLog(@"注册失败");
    [SVProgressHUD showErrorWithStatus:@"用户名不可用" duration:1.5];
    
    [xmppStream disconnect];
}
//注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
    [SVProgressHUD showSuccessWithStatus:@"注册成功，恭喜你" duration:1.5];
    
    [self disconnect];
    [loginview.rigistView dismissViewControllerAnimated:NO completion:nil];
    loginview.unametext.text=loginview.rigistView.unametext.text;
    loginview.upasstext.text=loginview.rigistView.upasstext.text;
}

-(void) sendMessage:(NSString *)_msg to:(NSString *)_to
{
    NSXMLElement * message=[NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@115.159.1.248",_to]];
    [message addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@115.159.1.248",loginview.unametext.text]];
    NSXMLElement * body=[NSXMLElement elementWithName:@"body"];
    [body setStringValue:_msg];
    [message addChild:body];
    //NSLog(@"%@",message);
    [xmppStream sendElement:message];
}


-(void)disconnect
{
    [self goOffline];
    [xmppStream disconnect];
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

//获得离线消息的时间
-(NSDate *)getDelayStampTime:(XMPPMessage *)message
{
    //获得xml中的delay标签
    XMPPElement * delay=(XMPPElement *)[message elementForName:@"delay"];
    if(delay)//如果是离线消息
    {
        //获得时间戳
        NSString * timeString=[[(XMPPElement *)[message elementForName:@"delay"] attributeForName:@"stamp"] stringValue];
        //时间格式化对象
        NSDateFormatter * dateFormatter=[[NSDateFormatter alloc] init];
        //设定时间的具体格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        //拆分到数组
        NSArray * arr=[timeString componentsSeparatedByString:@"T"];
        //日期
        NSString * dateStr=[arr objectAtIndex:0];
        NSString * timeStr=[[[arr objectAtIndex:1] componentsSeparatedByString:@"."] objectAtIndex:0];
        //构建一个日期对象 这个对象里的时区是0
        NSDate * localDate=[dateFormatter dateFromString:[NSString stringWithFormat:@"%@T%@+0000",dateStr,timeStr]];
        return localDate;
    }
    else
    {
        return nil;
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"message %@",message);
   NSDate * date=[self getDelayStampTime:message];
    if(date==nil)
    {
        date=[NSDate date];
    }
    //NSDate  * date=[NSDate date];
    NSDateFormatter * dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString * datestr=[dateFormatter stringFromDate:date];
    NSDateFormatter * dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString * timestr=[dateFormatter2 stringFromDate:date];
    NSLog(@"%@",datestr);
    NSLog(@"%@",timestr);
    XMPPJID * jid=[message from];
    NSString * body=[[message elementForName:@"body"] stringValue];
    body=[NSString stringWithFormat:@"%@:%@",[jid user],body];
    NSString * username1=[jid user];
    NSLog(@" %@",body);
    BOOL b=[self.db executeUpdate:@"insert into messages values(?,?,?,?,?,?)",username1,datestr,timestr,body,@"0",@""];
    if(!b)
    {
        NSLog(@"insert failed");
    }
    
    NSNotification * note=[[NSNotification alloc]initWithName:@"come" object:[NSString stringWithFormat:@"%@,%@,%@",username1,timestr,body] userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    MessageTableViewController * msg= [DYFUtil MessageTableViewController];
    [msg showNumber];

    //msg.tabBarItem.badgeValue=@"5";
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    
    NSLog(@"断开连接%@",error);
    //[DYFUtil alertWithMessage:@"与服务器断开连接，请稍后再试。"];
}


- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "--.__" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"__" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"__.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext
{
  
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
