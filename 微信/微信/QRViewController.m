//
//  QRViewController.m
//  微信
//
//  Created by 邓云方 on 15/10/16.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "QRViewController.h"
#import  "QRCodeGenerator.h"
@interface QRViewController ()

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的二维码";
    self.view.backgroundColor=[UIColor grayColor];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
    imageView.image =[QRCodeGenerator qrImageForString:@"草" imageSize:300];
    [self.view addSubview: imageView];
    // Do any additional setup after loading the view.
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
