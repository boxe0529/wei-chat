//
//  detailViewController.h
//  微信
//
//  Created by 邓云方 on 15/10/13.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSMutableArray * mesgs;
@property (strong,nonatomic) NSString * uname;
@end
