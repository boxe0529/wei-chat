//
//  AppDelegate.h
//  微信
//
//  Created by 邓云方 on 15/10/11.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"
#import  "FMDatabase.h"
#import "LoginViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPStreamDelegate>
@property (assign,nonatomic) BOOL isRegist;
@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (strong,nonatomic)NSString *password;
@property (strong,nonatomic)NSString * username;
@property (strong,nonatomic) FMDatabase * db;
-(void) sendMessage:(NSString *)_msg to:(NSString *)_to;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (BOOL)connectWithUserName:(NSString * )_uname andPassword:(NSString*)_upass;
//@property (assign,nonatomic) CGSize size;
-(NSDate *)getDelayStamTime:(XMPPMessage *)message;
@end

