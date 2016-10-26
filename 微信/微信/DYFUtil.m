//
//  DYFUtil.m
//  微信
//
//  Created by 邓云方 on 15/10/12.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "DYFUtil.h"
static MessageTableViewController * msg=nil;
static NSString * username=nil;
static NSString * userpasswrord=nil;
@implementation DYFUtil

+(void)alertWithMessage:(NSString *)_msg
{
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:_msg delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
}

+(void)setMessageView:( MessageTableViewController*)_msgview;
{
    msg=_msgview;
}

+(MessageTableViewController *) MessageTableViewController;
{
    return msg;
}
+(void)setUserName:(NSString *)_uname
{
    username=_uname;
}
+(NSString *)userName
{
    return username;
}
+(void)setUserPassword:(NSString *)_upass
{
    userpasswrord=_upass;
}
+(NSString *)userPass
{
    return userpasswrord;
}
@end
