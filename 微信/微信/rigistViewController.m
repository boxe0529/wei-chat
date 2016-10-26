//
//  rigistViewController.m
//  微信
//
//  Created by 邓云方 on 15/10/13.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "rigistViewController.h"
#import "LoginViewController.h"
@interface rigistViewController ()

@end

@implementation rigistViewController
@synthesize unametext,upasstext;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    int width=[UIScreen mainScreen].bounds.size.width;
    int height=[UIScreen mainScreen].bounds.size.height;
    
    UIButton * tijiao2=[[UIButton alloc]initWithFrame:CGRectMake(20, 30, 60, 30)];
    [tijiao2 setTitle:@"返回" forState:UIControlStateNormal];
    //tijiao2.backgroundColor=[UIColor greenColor];
    [tijiao2 setTintColor:[UIColor blackColor]];
    [tijiao2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tijiao2 addTarget:self action:@selector(tijaotap2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tijiao2];
    
    UILabel * head=[[UILabel alloc]initWithFrame:CGRectMake(80, 90, 200, 40)];
    head.text=@"注册填写个人信息";
    head.font=[UIFont systemFontOfSize:24];
    [self.view addSubview:head];
    
    UILabel * unamelable=[[UILabel alloc]initWithFrame:CGRectMake(width/8, height/4, width/5, height/12)];
    //unamelable.backgroundColor=[UIColor grayColor];
    unamelable.text=@"账号：";
    unamelable.font=[UIFont systemFontOfSize:20];
    [self.view addSubview:unamelable];
    
    UILabel * upasslable=[[UILabel alloc]initWithFrame:CGRectMake(width/8, height/4+height/12, width/5, height/12)];
    //upasslable.backgroundColor=[UIColor grayColor];
    upasslable.text=@"密码：";
    upasslable.font=[UIFont systemFontOfSize:20];
    [self.view addSubview:upasslable];
    
    UILabel * upasslable2=[[UILabel alloc]initWithFrame:CGRectMake(width/8, height/4+height/12+height/12, width/5, height/12)];
    //upasslable.backgroundColor=[UIColor grayColor];
    upasslable2.text=@"重复：";
    upasslable2.font=[UIFont systemFontOfSize:20];
    [self.view addSubview:upasslable2];
    
    unametext=[[UITextField alloc]initWithFrame:CGRectMake(width/3.5, height/4, width/2, height/12)];
    unametext.placeholder=@"请输入账号";
    [self.view addSubview:unametext];
    
    upasstext=[[UITextField alloc]initWithFrame:CGRectMake(width/3.5, height/4+height/12, width/2, height/12)];
    upasstext.placeholder=@"请输入密码";
    upasstext.secureTextEntry=YES;
    [self.view addSubview:upasstext];
    
    upasstext2=[[UITextField alloc]initWithFrame:CGRectMake(width/3.5, height/4+height/12+height/12, width/2, height/12)];
    upasstext2.placeholder=@"请输入密码";
    upasstext2.secureTextEntry=YES;
    [self.view addSubview:upasstext2];
    
    UIButton * tijiao=[[UIButton alloc]initWithFrame:CGRectMake(150, 450, 60, 40)];
    [tijiao setTitle:@"提交" forState:UIControlStateNormal];
    tijiao.backgroundColor=[UIColor greenColor];
    [tijiao addTarget:self action:@selector(tijaotap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tijiao];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    self.unametext.text=self.strname;
    self.upasstext.text=self.strpass;
}

-(void)tijaotap:(id)sender
{
   
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    NetworkStatus status= [reach currentReachabilityStatus];
    if(status==NotReachable)
    {
        [DYFUtil alertWithMessage:@"无可用网络，请检查网络连接"];
        return ;
    }
    
    NSString * uname=unametext.text;
    NSString * upass=upasstext.text;
     NSString * upass2=upasstext2.text;
    uname=[uname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    upass=[upass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    upass2=[upass2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([uname isEqualToString:@""]||[upass isEqualToString:@""]||[upass2 isEqualToString:@""])
    {
        [DYFUtil alertWithMessage:@"username or password couldn't be whitespace"];
        [unametext becomeFirstResponder];
        return;
    }
    if(![upass2 isEqualToString:upass])
    {
        [DYFUtil alertWithMessage:@"密码不一致"];
        [upasstext becomeFirstResponder];
        return;
    }
       [SVProgressHUD showWithStatus:@"注册中..." maskType:SVProgressHUDMaskTypeGradient];
    AppDelegate * app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    app.isRegist=YES;
    [app connectWithUserName:uname andPassword:upass];


}
-(void)tijaotap2:(id)sender
{

    NSLog(@" fanhui");
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
