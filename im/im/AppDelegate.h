//
//  AppDelegate.h
//  im
//
//  Created by 邓云方 on 15/10/10.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import <CoreData/CoreData.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, XMPPRosterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (strong,nonatomic)NSString *password;
@end

