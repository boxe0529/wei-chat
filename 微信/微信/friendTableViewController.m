//
//  friendTableViewController.m
//  微信
//
//  Created by 邓云方 on 15/10/12.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "friendTableViewController.h"
#import "addViewController.h"
#import "detailViewController.h"
@interface friendTableViewController ()
{
    NSMutableArray * users;
}

@end

@implementation friendTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * add=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addtap:)];
    self.navigationItem.rightBarButtonItem=add;
    users=[[NSMutableArray alloc]initWithCapacity:100];
    
    AppDelegate * app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * db=[app db];
   FMResultSet * rs= [db executeQuery:@"select * from friends"];
    while ([rs next])
    {
        [users addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)addtap:(id)sender
{
    addViewController * add=[[addViewController alloc]init];
    [self presentViewController:add animated:NO completion:nil];
    add.frid=self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return users.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.imageView.image=[UIImage imageNamed:@"16.png"];
    cell.textLabel.text=users[indexPath.row];
    // Configure the cell...
    
    return cell;
}

-(void)addFridend:(NSString * )_name
{
    BOOL b=NO;
   for( NSString * str in users)
   {
       if([str isEqualToString:_name])
       {
           b=YES;
          
       }
   }
    if(b==NO)
    {
    AppDelegate * app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * db=[app db];
   //FMResultSet *rs= [db executeQuery:@"select * from friends where username=?",_name];
    
    [db executeUpdate:@"insert into friends values(?)",_name];
     [users addObject:_name];
        [self.tableView reloadData];}
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailViewController *detail=[[detailViewController alloc]initWithNibName:nil bundle:nil];
    detail.uname=users[indexPath.row];
    [self presentViewController:detail animated:NO completion:nil];
}
@end
