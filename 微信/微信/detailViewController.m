//
//  detailViewController.m
//  微信
//
//  Created by 邓云方 on 15/10/13.
//  Copyright (c) 2015年 邓云方. All rights reserved.
//

#import "detailViewController.h"
#import "MessageTableViewController.h"
@interface detailViewController ()
{
    MessageTableViewController * mesgview;
}
- (IBAction)backtap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)editbegin:(id)sender;
- (IBAction)closekey:(id)sender;
- (IBAction)editend:(id)sender;
- (IBAction)beijingclosekey:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendertap;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)sendtap:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *sendtext;
@property (retain, nonatomic) UILabel * sendAndTimeLable;
@property (retain, nonatomic) UITextView * messageControlView;
@property (retain, nonatomic) UIImageView * bgImageView;
@end

@implementation detailViewController
@synthesize mesgs;
- (void)viewDidLoad {
    [super viewDidLoad];
    mesgs=[[NSMutableArray alloc]initWithCapacity:200];
    //self.view.backgroundColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.4 alpha:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comemessage:) name:@"come" object:nil];
    self.label.text=self.uname;
    AppDelegate * app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    FMResultSet * rs= [app.db executeQuery:@"select * from messages where username=?",self.uname];
    while ([rs next])
    {
        DYFMessage * messages=[[DYFMessage alloc]init];
        messages.username=self.uname;
        messages.body=[rs stringForColumnIndex:3];
        messages.time=[rs stringForColumnIndex:2];
        messages.flag=[rs intForColumnIndex:4];
        messages.me=[rs stringForColumnIndex:5];
        [self.mesgs addObject:messages];
       [app.db executeUpdate:@"update messages set flag=1 where username=? and time=?  and msg=?",messages.username,messages.time,messages.body];
       //NSLog(@"%@ %@ %@ ",messages.username,messages.time,messages.body);
    }
    [[DYFUtil MessageTableViewController] showNumber];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    //self.tableview= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self.tableview) {
        //日期标签
        _sendAndTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
        //居中显示
        _sendAndTimeLable.textAlignment = UITextAlignmentCenter;
        _sendAndTimeLable.font = [UIFont systemFontOfSize:11.0];
        //文字颜色
        _sendAndTimeLable.textColor = [UIColor lightGrayColor];
        [_tableview addSubview:_sendAndTimeLable];
      
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.tableview addSubview:_bgImageView];
        //聊天信息
        _messageControlView = [[UITextView alloc] init];
        _messageControlView.backgroundColor = [UIColor clearColor];
        //不可编辑
        _messageControlView.editable = NO;
        _messageControlView.scrollEnabled = NO;
        [_messageControlView sizeToFit];
        [self.tableview addSubview:_messageControlView];
    }
    return self;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.label resignFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated
{
    if(self.tableview.contentSize.height-self.tableview.bounds.size.height>0)
    {
        
        [self.tableview setContentOffset:CGPointMake(0, self.tableview.contentSize.height-self.tableview.bounds.size.height) animated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backtap:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mesgs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    DYFMessage * msg=self.mesgs[indexPath.row];
    //CIImage * im=[[CIImage alloc]initWithImage:[UIImage imageNamed:@"46.png"]];
    //cell.imageView.image=[UIImage imageNamed:@"46.png"];
    //UIImage imageWithCIImage:im scale:0.1 orientation:UIImageOrientationUpMirrored];
   //UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(110, 8, 120, 30)];
    //l1.textAlignment=NSTextAlignmentRight;
   // cell.textLabel.text=msg.time;
   // cell.detailTextLabel.text=msg.body;
    

    if ([msg.me isEqualToString:@"me"] && msg.flag==1)
    {
        cell.imageView.image=nil;
        UIButton * numlabel=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        //numlabel.layer.cornerRadius=20;
        UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(110, 8, 120, 30)];
        l1.textAlignment=NSTextAlignmentRight;
        //[cell addSubview:l1];
        //UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(110, 8, 120, 30)];
        l1.text=msg.body;
        
        //l1.backgroundColor=[UIColor redColor];
        
        //numlabel.titleLabel.font = [UIFont systemFontOfSize: 18.0];
        //[numlabel setImage:[UIImage imageNamed:@"41.png"] forState:UIControlStateNormal];
        //[numlabel setTitle: [NSString stringWithFormat:@"%@",msg.me]forState:UIControlStateNormal];
        [numlabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[numlabel setTitleShadowColor:[UIColor redColor] forState:UIControlStateNormal];
        //numlabel.backgroundColor=[UIColor redColor];
        [numlabel setImage:[UIImage imageNamed:@"16.png"] forState:UIControlStateNormal];
        cell.textLabel.text=msg.body;
        cell.detailTextLabel.text=msg.time;
        //numlabel.imageView.image=[UIImage imageNamed:@"16.png"];
        cell.accessoryView=numlabel;
      
    }
   else
   {
    
        ////l1.text=nil;
        cell.accessoryView=nil;
       cell.imageView.image=[UIImage imageNamed:@"46.png"];
       cell.textLabel.text=msg.body;
       cell.detailTextLabel.text=msg.time;
    
   }
  // UIImage * bgImage = [[UIImage imageNamed:@"123.jpg"] stretchableImageWithLeftCapWidth:14 topCapHeight:15];
    cell.backgroundColor=[UIColor colorWithRed:0.1 green:0.7 blue:0.2 alpha:0.1];
  //  cell.backgroundView=(UIView *)bgImage;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.label resignFirstResponder];
}
- (IBAction)editbegin:(UITextField * )sender
{
    CGRect frame = sender.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 256.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    //NSLog(@"edit begin");
}
-(void)comemessage:(id)sender
{
   // NSLog(@"%@",[sender object]);
    NSString * str=[sender object];
    NSArray * arr=[str componentsSeparatedByString:@","];
    NSString * username=arr[0];
    NSString * time=arr[1];
    NSLog(@"%@",time);
    NSString * body=arr[2];
    NSLog(@"%@",body);
    DYFMessage * msg=[[DYFMessage alloc]init];
    msg.username=username;
    msg.time=time;
    msg.body=body;
    msg.flag=1;
    [self.mesgs addObject:msg];
    AppDelegate * app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    FMDatabase * db=[app db];
    [db executeUpdate:@"update messages set flag=1 where username=? and time=? and msg=?",username,time,body ];
    [self.tableview reloadData];
    
    if(self.tableview.contentSize.height-self.tableview.bounds.size.height>0)
    {
        
        [self.tableview setContentOffset:CGPointMake(0, self.tableview.contentSize.height-self.tableview.bounds.size.height) animated:YES];
    }

}
- (IBAction)closekey:(UITextField * )sender
{
    
    
}

- (IBAction)editend:(id)sender {
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (IBAction)beijingclosekey:(id)sender
{
    
    [self.view endEditing:YES];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


- (IBAction)sendtap:(id)sender
{
    NSString * msg=self.sendtext.text;
    msg=[msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([msg isEqualToString: @""])
    {
        [SVProgressHUD showErrorWithStatus:@"文本不能为空" duration:1.4];
    }
    else
    {
        AppDelegate * app=(AppDelegate * )[UIApplication sharedApplication].delegate;
        
        [app sendMessage:msg to:self.uname];
        //本地保存
        FMDatabase * db=[app db];
       // NSString * sql=@"insert into messages values(?,?,?,?,?,?)";
        NSDate * date=[NSDate date];
        NSDateFormatter * dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString * datestr=[dateFormatter stringFromDate:date];
        NSDateFormatter * dateFormatter2=[[NSDateFormatter alloc]init];
        [dateFormatter2 setDateFormat:@"HH:mm"];
        NSString * timestr=[dateFormatter2 stringFromDate:date];
        
        [db executeUpdate:@"insert into messages values(?,?,?,?,?,?)",self.uname,datestr,timestr,msg,@"1",@"me"];
        
        DYFMessage * message=[[DYFMessage alloc]init];
        message.username=self.uname;
        message.date=datestr;
        message.time=timestr;
        message.flag=1;
        message.body=msg;
        message.me=@"me";
        [self.mesgs addObject:message];
        [self.tableview reloadData];
        
        [self.sendtext resignFirstResponder];
        
        if(self.tableview.contentSize.height-self.tableview.bounds.size.height>0)
        {
            
            [self.tableview setContentOffset:CGPointMake(0, self.tableview.contentSize.height-self.tableview.bounds.size.height) animated:YES];
        }

    }
    
    
    
    
}
@end
