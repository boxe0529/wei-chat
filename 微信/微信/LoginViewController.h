//
//  LoginViewController.h
//  微信
//
//  Created by 邓云方 on 15/10/11.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rigistViewController.h"
#import "AppDelegate.h"
@interface LoginViewController : UIViewController
{
    BOOL isremeber;
    UIButton * remberbtn;
}
@property(strong,nonatomic) UITextField * unametext;
@property(strong,nonatomic) UITextField * upasstext;
@property(strong,nonatomic) rigistViewController * rigistView;
-(void)showMainView;
-(void)showNumber;
@end
