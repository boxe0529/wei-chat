//
//  DYFUtil.h
//  微信
//
//  Created by 邓云方 on 15/10/12.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageTableViewController.h"
@interface DYFUtil : NSObject
+(void)alertWithMessage:(NSString *)_msg;
+(void)setMessageView:(MessageTableViewController *)_msgview;
+(MessageTableViewController *) MessageTableViewController;
+(void)setUserName:(NSString *)_uname;
+(NSString *)userName;
+(void)setUserPassword:(NSString *)_upass;
+(NSString *)userPass;
@end
