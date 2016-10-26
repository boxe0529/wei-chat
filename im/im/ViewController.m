//
//  ViewController.m
//  im
//
//  Created by 邓云方 on 15/10/10.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor orangeColor];
    
    UILabel * l1=[[UILabel alloc]initWithFrame:CGRectMake(50, 70, 60, 40)];
    l1.text=@"账号：";
    UITextField *t1=[[UITextField alloc]initWithFrame:CGRectMake(130, 70, 220, 40)];
    t1.placeholder=@"请输入账号";
    t1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:t1];
    UILabel * l2=[[UILabel alloc]initWithFrame:CGRectMake(50, 130, 60, 40)];
    l2.text=@"密码：";
    UITextField *t2=[[UITextField alloc]initWithFrame:CGRectMake(130, 130, 220, 40)];
    t2.placeholder=@"请输入密码";
    t2.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:t2];
    UIButton * b1=[[UIButton alloc]initWithFrame:CGRectMake(80, 190, 220, 40)];
    [b1 setTitle:@"登录" forState:UIControlStateNormal];
    b1.backgroundColor=[UIColor redColor];
    [self.view addSubview:l1];
    [self.view addSubview:l2];
    [self.view addSubview:b1];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
