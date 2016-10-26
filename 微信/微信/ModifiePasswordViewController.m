//
//  ModifiePasswordViewController.m
//  微信
//
//  Created by 邓云方 on 15/10/16.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "ModifiePasswordViewController.h"

@interface ModifiePasswordViewController ()
- (IBAction)backtap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *oldpassword;
@property (weak, nonatomic) IBOutlet UITextField *newpassword;
@property (weak, nonatomic) IBOutlet UITextField *reputword;
- (IBAction)modifytap:(id)sender;
- (IBAction)closekey:(id)sender;

@end

@implementation ModifiePasswordViewController

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

- (IBAction)backtap:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)modifytap:(id)sender {
    NSLog(@"%@ %@",[DYFUtil userName],[DYFUtil userPass]);
    NSString * nameurl=[DYFUtil userName];
    NSString * old=self.oldpassword.text;
    NSString * new=self.newpassword.text;
    NSString * renew=self.reputword.text;
    old=[old stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    new=[new stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    renew=[renew stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([old isEqualToString:@""]||[new isEqualToString:@""]||[renew isEqualToString:@""])
    {
        [DYFUtil alertWithMessage:@" password couldn't be whitespace"];
        [self.oldpassword becomeFirstResponder];
        return;
    }
    if([old isEqualToString:[DYFUtil userPass]])
    {
        if([new isEqualToString: renew])
        {
            NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"http://115.159.1.248:9090/plugins/userService/userservice?type=update&secret=xIq1xQ49&username=%@&password=%@",nameurl,new]];
            NSURLRequest * request=[[NSURLRequest alloc]initWithURL:url];
            NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            if(data)
            {
                NSString * str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSRange  range=[str rangeOfString:@"ok"];
                if(range.location!=NSNotFound)
                {
                    [SVProgressHUD showSuccessWithStatus:@"密码修改成功!" duration:1.5];
                    [self dismissViewControllerAnimated:NO completion:nil];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:@"密码修改失败,请稍后再试" duration:1.5];

                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"密码修改失败,请稍后再试" duration:1.5];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"两次密码不一致" duration:1.5];
            [self.reputword becomeFirstResponder];
            return;
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"原密码错误" duration:2];
        [self .oldpassword becomeFirstResponder];
        return;
    }
}

- (IBAction)closekey:(id)sender {
}
@end
