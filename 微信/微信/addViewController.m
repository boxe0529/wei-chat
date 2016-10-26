//
//  addViewController.m
//  微信
//
//  Created by 邓云方 on 15/10/15.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "addViewController.h"
#import "friendTableViewController.h"
@interface addViewController ()
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *username;
- (IBAction)search:(id)sender;

@end

@implementation addViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)search:(id)sender {
    NSString * username=self.username.text;
    username=[username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([username isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"账户为空" duration:1.5];
        self.username.text=@"";
        [self.username becomeFirstResponder];
        return;
    }
    //221.7.12.85
    NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"http://115.159.1.248:56666/weixin/isexists.php?id=%@",username]];
    NSURLRequest * request=[NSURLRequest requestWithURL:url];
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil ];
    if(data==nil)
    {
        [SVProgressHUD showErrorWithStatus:@"查找不到账号" duration:1.5];
        [self.username becomeFirstResponder];
        return;
    }
    else
    {
        //NSString * str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSArray * ar=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if(ar)
        {
            
            [self.frid addFridend:username];
            [SVProgressHUD showSuccessWithStatus:@"好友已经添加成功" duration:1.5];
            [self dismissViewControllerAnimated:NO completion:nil];
  
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"无效的用户名" duration:1.5];
        }
    }
}
/*修改用户密码
 http://115.159.1.248:9090/plugins/userService/userservice?type=update&secret=xIq1xQ49&username=zhq&password=1234
 2.判断是否有这个用户
 http://115.159.1.248:56666/weixin/isexists.php?id=%@username
 这个是我赢微信的接口*/
@end
