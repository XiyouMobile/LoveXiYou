//
//  showBook.m
//  http2
//
//  Created by  on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "showBook.h"
#import "UIViewController+AddTitleView.h"
#define urlPath @"http://222.24.63.101/library/renew"
@implementation showBook
@synthesize myTableView = _myTableView;
@synthesize bookArr = _bookArr;
@synthesize bookListString = _bookListString;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc{
    [super dealloc];
    [myTableView release], myTableView = nil;
    [bookArr release], bookArr = nil;
}
#pragma mark set-time Delegate
-(NSUInteger) compareCurrentTime:(NSDate*) compareDate                        
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    NSUInteger temp = 0;
    temp = timeInterval/(24*60*60);
    return  temp + 1;
}

-(NSDate *)stringToDate:(NSString *)aString
{
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    return [formatter dateFromString:aString];
}

-(void)renewing:(id)sender
{
    UIButton *aa = (UIButton *)sender;
    index = aa.tag;
    [MobClick event:@"续借"];
    [self Request];
}
-(void)Request{
    NSURL *url0 = [NSURL URLWithString:urlPath];
    ASIFormDataRequest *request0 = [[ASIFormDataRequest alloc] initWithURL:url0];
    NSLog(@"index = %d",index);
    NSDictionary *books = [_bookArr objectAtIndex:index];
    NSString * Bid = [books objectForKey:@"barcode"];
    NSString * Bde = [books objectForKey:@"department_id"];
    NSString * Bli = [books objectForKey:@"library_id"];
    
    [request0 setPostValue:Bid forKey:@"barcode"];
    [request0 setPostValue:Bde forKey:@"department_id"];
    [request0 setPostValue:Bli forKey:@"library_id"];
    [request0 startSynchronous];
    
    [self remind:[request0 responseString]];
    
    
}
-(void)remind:(NSString *)htmlData      //分为续借成功和续借不成功（有分：已经续借过，超期，系统异常）
{
    if([htmlData isEqualToString:@"ok"] )
    {
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"续借成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [myAlert show];
        [myAlert release];

        _bookListString = [delegate bookListRequest];
            _bookArr = [[NSJSONSerialization JSONObjectWithData:[_bookListString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil] copy];
        [_myTableView reloadData];
        [self locationAlert];
    }
    else
    {
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"续借失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [myAlert show];
        [myAlert release];
    }
}

-(void)locationAlert{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSMutableArray *dateArray = [NSMutableArray array];
    
    for (int i = 0; i <(int) [_bookArr count] -1; i++) {
        [dateArray addObject:[[_bookArr objectAtIndex:i] objectForKey:@"date"]];
    }
    if ([dateArray count]) {
        NSLog(@"dateArr = %@",dateArray);
        [dateArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        NSLog(@"dateArr = %@",dateArray);
        NSString *nextDateString = [dateArray objectAtIndex:0];
        UILocalNotification *ln = [[UILocalNotification alloc] init];
        ln.alertBody = @"你有书今天要还，请点击显示查看详情。";
        ln.fireDate = [self stringToDate:nextDateString];
        ln.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:ln];
        [ln release];
        NSLog(@"%@",[self stringToDate:nextDateString]);
    }


}

#pragma mark - View lifecycle

- (void)viewDidLoad
{    
    [super viewDidLoad];  
	[self setleftBarButtonItem:nil orImaged:@"邮电绿色导航返回按钮" Event:@selector(done:)];

    self.navigationItem.title = @"我的借阅";
    _bookArr = [[NSJSONSerialization JSONObjectWithData:[_bookListString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil] copy];
    NSLog(@"arr = %@",_bookArr);
    if ([_bookArr count] == 0)
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showAlert:) userInfo:nil repeats:NO];
    }
    
    [self locationAlert];
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    [self.view addSubview:_myTableView];
}

#pragma mark - AlertView Delegate
- (void)showAlert:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您目前没有借书" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    
    [alert show];
    [alert release];
    [self done:NULL];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - table dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    book = [NSDictionary dictionaryWithDictionary:[_bookArr objectAtIndex:indexPath.section]];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    [cell.textLabel setFont:[UIFont fontWithName:@"Cochin Bold" size:17]];
    switch ([indexPath row]) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"图 书 条 码：%@",[book objectForKey:@"barcode"]];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[book objectForKey:@"name"]];
            [cell.textLabel setNumberOfLines:2];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"应 还 日 期：%@",[book objectForKey:@"date"]];
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"流 通 状 态：%@",[book objectForKey:@"state"]];
            break;
        case 4:
        {
            int limitDate = [self compareCurrentTime:[self stringToDate:[book objectForKey:@"date"]]];
            if (limitDate < 3) {
                cell.textLabel.textColor = [UIColor redColor];
            }
            if (limitDate > 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"离 还 书 日 期 还 有 %d 天",limitDate];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"已 超 还 书 日 期 %d 天",-limitDate];
            }
        }
            break;
        case 5:{
            UIButton * renew = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [renew setFrame:CGRectMake(10, 0,300,44)];
            [renew.titleLabel setFont:[UIFont fontWithName:@"Cochin Bold" size:17]];
            [renew setTag:indexPath.section];
            if ([[book objectForKey:@"isRenew"] intValue]) {
                    [renew setImage:[UIImage imageNamed:@"邮电绿色续借"] forState:UIControlStateNormal];
                    [renew addTarget:self action:@selector(renewing:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [renew setImage:[UIImage imageNamed:@"邮电绿色不可续借"] forState:UIControlStateNormal];  
            }
            [cell addSubview:renew];
        }
            
        default:
            break;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_bookArr count]-1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


- (void)done:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
