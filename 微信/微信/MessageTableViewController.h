//
//  MessageTableViewController.h
//  微信
//
//  Created by 邓云方 on 15/10/12.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewController : UITableViewController<UINavigationControllerDelegate>
@property (strong,nonatomic)NSMutableArray * megs;
-(void)showNumber;
@end
