//
//  MessageTableViewController.m
//  微信
//
//  Created by 邓云方 on 15/10/12.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "MessageTableViewController.h"
#import  "LoginViewController.h"
#import "detailViewController.h"
@interface MessageTableViewController ()
{
    LoginViewController * login;
}
@end

@implementation MessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.megs=[[NSMutableArray alloc]initWithCapacity:200];
    [self showNumber];
   

}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self showNumber];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.megs.count ;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    DYFMessage * msg=self.megs[indexPath.row];
    cell.textLabel.text=msg.username;
    cell.detailTextLabel.text=msg.body;
    if(msg.flag>0){
    UIButton * numlabel=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
    numlabel.layer.cornerRadius=7;
    numlabel.titleLabel.font = [UIFont systemFontOfSize: 11.0];
    //[numlabel setImage:[UIImage imageNamed:@"41.png"] forState:UIControlStateNormal];
    [numlabel setTitle: [NSString stringWithFormat:@"%d",msg.flag]forState:UIControlStateNormal];
    [numlabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [numlabel setTitleShadowColor:[UIColor redColor] forState:UIControlStateNormal];
     numlabel.backgroundColor=[UIColor redColor];
        cell.accessoryView=numlabel;}
    else
    {
        cell.accessoryView=nil;
    }
    
    
    //cell.detailTextLabel.text=@"hello";
    cell.imageView.image=[UIImage imageNamed:@"16.png"];
    // Configure the cell...
    
    return cell;
}
-(void)showNumber
{
    AppDelegate * app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * db=app.db;
    FMResultSet * rs= [db executeQuery:@"select count(*) from messages where flag=0"];
    [rs next];
    NSString * num=[rs stringForColumnIndex:0];
    //NSLog(@"%@",num);
    
    if(![num intValue]==0)
    {
      // self.tabBarItem.badgeValue=num;
        self.navigationController.tabBarItem.badgeValue=num;
    }
    else
    {
        self.navigationController.tabBarItem.badgeValue=nil;
    }
    [rs close];
    [self.tableView reloadData];
    rs= [db executeQuery:@"select username from messages group by username"];
    //获得用户消息的列表
    [self.megs removeAllObjects];
    
    while ([rs next])
    {
        DYFMessage * msg=[[DYFMessage alloc]init];
        msg.username=[rs stringForColumnIndex:0];
        msg.flag=[[rs stringForColumnIndex:1] intValue];
        [self.megs addObject:msg];
    }
    [rs close];
    NSLog(@"%d",self.megs.count);
    [self.tableView reloadData];
    for(DYFMessage * msg in self.megs)
    {
    rs=[db executeQuery:@"select msg from messages where username=? order by time desc limit 0,1",msg.username];
        [rs next];
        msg.body=[rs stringForColumnIndex:0];
        [rs close];
        
        rs=[app.db executeQuery:@"select count(*) from messages where username=? and flag=0",msg.username];
        [rs next];
        msg.flag=[rs intForColumnIndex:0];
        //NSLog(@"%d",msg.flag);
    }
    [rs close];
    NSLog(@"%d",self.megs.count);
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DYFMessage * msg=self.megs[indexPath.row];
    detailViewController *detail=[[detailViewController alloc]initWithNibName:nil bundle:nil];
    detail.uname=msg.username;
    [self presentViewController:detail animated:NO completion:nil];
}
@end
