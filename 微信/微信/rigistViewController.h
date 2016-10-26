//
//  rigistViewController.h
//  微信
//
//  Created by 邓云方 on 15/10/13.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rigistViewController : UIViewController
{
    UITextField * unametext;
    UITextField*  upasstext;
     UITextField*  upasstext2;
}
@property (strong,nonatomic ) NSString * strname;
@property (strong,nonatomic ) NSString * strpass;
@property(strong,nonatomic) UITextField * unametext;
@property(strong,nonatomic) UITextField * upasstext;
@end
