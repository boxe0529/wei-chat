//
//  LoginViewController.m
//  微信
//
//  Created by 邓云方 on 15/10/11.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MessageTableViewController.h"
#import "friendTableViewController.h"
#import "searchTableViewController.h"
#import "settingTableViewController.h"
#import "rigistViewController.h"

@interface LoginViewController ()
@property (strong,nonatomic)UINavigationController * navMessage;
@end

@implementation LoginViewController
@synthesize unametext,upasstext;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //头像
    
    int width=[UIScreen mainScreen].bounds.size.width;
    int height=[UIScreen mainScreen].bounds.size.height;
    
    UIImageView * heardImage=[[UIImageView alloc]initWithFrame:CGRectMake((width-60)/2,100, 60, 60)];
    heardImage.image=[UIImage imageNamed:@"16.png"];
    [self.view addSubview:heardImage];
    /*
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
    */
    unametext=[[UITextField alloc]initWithFrame:CGRectMake(width/4, 175, width/2, 30)];
    unametext.font=[UIFont systemFontOfSize:15];
    unametext.placeholder=@"请输入账号";
   
    unametext.textAlignment=NSTextAlignmentCenter;
    UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(width/12, 200, width/1.2, 1)];
    l1.backgroundColor=[UIColor greenColor];
    [self.view addSubview:l1];
    [self.view addSubview:unametext];
    
    upasstext=[[UITextField alloc]initWithFrame:CGRectMake(width/4, 225, width/2, 30)];
    upasstext.font=[UIFont systemFontOfSize:15];
     upasstext.placeholder=@"请输入密码";
    upasstext.textAlignment=NSTextAlignmentCenter;
     upasstext.secureTextEntry=YES;
    UILabel *l2=[[UILabel alloc]initWithFrame:CGRectMake(width/12, 250, width/1.2, 1)];
    l2.backgroundColor=[UIColor greenColor];
    [self.view addSubview:l2];
    [self.view addSubview:upasstext];
    
    remberbtn=[[UIButton alloc]initWithFrame:CGRectMake(40, 270, 20, 20 )];
    [remberbtn setImage:[UIImage imageNamed:@"discheck.png"] forState:UIControlStateNormal];
    [remberbtn addTarget:self action:@selector(rembertap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:remberbtn];
    
    UILabel * rembnamelable=[[UILabel alloc]initWithFrame:CGRectMake(75,270, width/6, 20)];
    //unamelable.backgroundColor=[UIColor grayColor];
    rembnamelable.text=@"记住账号";
    rembnamelable.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:rembnamelable];
    
    UIButton * loginbtn=[[UIButton alloc]initWithFrame:CGRectMake(width/5, 320, width*0.6, 30)];
    loginbtn.backgroundColor=[UIColor greenColor];
    [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginbtn addTarget:self action:@selector(logintap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbtn];
    
    UIButton * registerbtn=[[UIButton alloc]initWithFrame:CGRectMake(width/5, 370, width*0.6, 30)];
    registerbtn.backgroundColor=[UIColor greenColor];
    [registerbtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerbtn addTarget:self action:@selector(registertap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerbtn];
    // Do any additional setup after loading the view.
}
-(void)rembertap:(id)sender
{
    if(isremeber==NO)
    {
        [remberbtn setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        isremeber=YES;
    }
    else
    {
        [remberbtn setImage:[UIImage imageNamed:@"discheck.png"] forState:UIControlStateNormal];
        isremeber=NO;
    }
}
-(void)logintap:(id)sender
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
    uname=[uname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    upass=[upass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([uname isEqualToString:@""]||[upass isEqualToString:@""])
    {
        [DYFUtil alertWithMessage:@"username or password couldn't be whitespace"];
        [unametext becomeFirstResponder];
        return;
    }
     [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeGradient];
    AppDelegate * app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    app.isRegist=NO;
    [app connectWithUserName:uname andPassword:upass];

}
-(void)showMainView
{
    //微信- 消息
    MessageTableViewController * message=[[MessageTableViewController alloc]initWithStyle:UITableViewStylePlain];
    message.title=@"微信";
    
    self.navMessage=[[UINavigationController alloc]initWithRootViewController:message];
    //通讯录－ 好友
    friendTableViewController * friends=[[friendTableViewController alloc]initWithStyle:UITableViewStylePlain];
    friends.title=@"通讯录";
        UINavigationController * navfriends=[[UINavigationController alloc]initWithRootViewController:friends];
    //发现
    searchTableViewController * search=[[searchTableViewController alloc]initWithStyle:UITableViewStylePlain];
    search.title=@"发现";
    UINavigationController * navsearch=[[UINavigationController alloc]initWithRootViewController:search];
    // 我  －设置
    settingTableViewController * setting=[[settingTableViewController alloc]initWithStyle:UITableViewStylePlain];
   setting.title=@"设置";
    UINavigationController * navsetting=[[UINavigationController alloc]initWithRootViewController:setting];
    UITabBarController * tab=[[UITabBarController alloc]init];
  [DYFUtil setMessageView:message];
    self.navMessage.tabBarItem.title=@"微信";
   self. navMessage.tabBarItem.image=[UIImage imageNamed:@"tab1.png"];
    [[DYFUtil MessageTableViewController] showNumber];
    //navMessage.tabBarItem.badgeValue=@"3";
    navfriends.tabBarItem.title=@"好友";
    navfriends.tabBarItem.image=[UIImage imageNamed:@"tab2.png"];
    navsearch.tabBarItem.title=@"发现";
    navsearch.tabBarItem.image=[UIImage imageNamed:@"tab3.png"];
    navsetting.tabBarItem.title=@"设置";
    navsetting.tabBarItem.image=[UIImage imageNamed:@"tab4.png"];
    
    [tab setViewControllers:[NSArray arrayWithObjects:self.navMessage,navfriends,navsearch,navsetting ,nil]];
    
    [self presentViewController:tab animated:NO completion:nil];
}
-(void)registertap:(id)sender
{
    _rigistView=[[rigistViewController alloc]init];
    self.rigistView.strname=self.unametext.text;
    self.rigistView.strpass=self.upasstext.text;
    [self presentViewController:_rigistView animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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
