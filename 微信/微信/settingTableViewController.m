//
//  settingTableViewController.m
//  微信
//
//  Created by 邓云方 on 15/10/12.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "settingTableViewController.h"
#import "RequestPostUploadHelper.h"
#import "ModifiePasswordViewController.h"
#import "QRViewController.h"
@interface settingTableViewController ()

@end

@implementation settingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(section==0)
    {
    return 1;
    }
    else
    {
        return 2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 35;
    }
    else
    {
        return 30;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0)
    {
        return 66;
        
    }
    else
    {
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {   //获得路径
        NSString * path=[[NSBundle mainBundle] pathForResource:@"46" ofType:@"png"];
        NSMutableDictionary * dir=[NSMutableDictionary dictionaryWithCapacity:7];
        [dir setValue:@"IOS上传试试" forKey:@"title"];
        NSString *url=@"http://127.0.0.1/up/up.php";
        //吧path拆分到数组 用户名.png
        NSArray *nameAry=[path componentsSeparatedByString:@"/"];
        //上传
        [RequestPostUploadHelper posttRequestWithURL:url postParems:dir picFilePath:path picFileName:@"16.png"];//用户名.png
        //  上传返回的信息
        NSLog(@"%@",[nameAry objectAtIndex:[nameAry count]-1]);
    }
    else if(indexPath.section==1 && indexPath.row==0)
    {
        ModifiePasswordViewController * modi=[[ModifiePasswordViewController alloc]init];
        [self presentViewController:modi animated:NO completion:nil];
    }
    else if(indexPath.section==1 && indexPath.row==1)
    {
        QRViewController *qr=[[QRViewController alloc]init];
        //压占模式
        [self.navigationController pushViewController:qr animated:YES];
        //[self presentViewController:qr animated:NO completion:nil];
    }
        
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if(indexPath.section==0)
    {
        cell.textLabel.text=@"我的头像";
        cell.imageView.image=[UIImage imageNamed:@"46.png"];
    }
    else
    {
        if(indexPath.row==0)
        {
            cell.textLabel.text=@"修改密码";
        }
        else
        {
            cell.textLabel.text=@"二维码";
        }
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
