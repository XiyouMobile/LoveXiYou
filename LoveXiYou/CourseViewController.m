//
//  CourseViewController.m
//  LoveXiYou
//
//  Created by  on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CourseViewController.h"
#import "UIViewController+AddTitleView.h"

@implementation CourseViewController

@synthesize currentArray;
@synthesize subject,teacher,address,beizhu;
@synthesize courseTableView;

@synthesize startPoint;

@synthesize disclosureView;
@synthesize day;
@synthesize Cday;
@synthesize tag;
@synthesize tagFather;
@synthesize arr;
@synthesize getarr;


- (void) reloadViewData{
    
    [arr removeAllObjects];
    PLSqliteDatabase * db = [Database setup];
    
    NSString * sql = [NSString stringWithFormat:@"select * from Lession%d",Cday];
    NSLog(@"-----%@----",sql);
    id<PLResultSet> rs = [db executeQuery:sql];
    while ([rs next])
    {
        Lession * les = [[Lession alloc] init];
        les.flag = [rs intForColumn:@"number"];
        les.subject = [rs stringForColumn:@"subject"];
        les.teacher = [rs stringForColumn:@"teacher"];
        les.address  = [rs stringForColumn:@"address"];
        les.beizhu = [rs stringForColumn:@"beizhu"];
        
        [arr addObject:les];
        [les release];
        les = nil;
        
    }
    [self.courseTableView reloadData];
}

- (void)listTo:(id)sender{
    if (isHidden == YES) {
        [spinner showList];
        isHidden = NO;
    }else {
        [spinner hiddenView];
        isHidden = YES;
    }
    
}

- (void)showList{
    // viewTag = _viewTag;
    
    [self setrightBarButtonItem:nil orImaged:@"邮电绿色导航新窗口按钮" Event:@selector(listTo:)];
    spinner = [[Spinner alloc] initWithFrame:CGRectMake(0, 0, 280, 352) data:currentArray view:self.view];
    spinner.delegate = self;
    NSLog(@"SPN Item: %@", spinner.title);
    
    [self.courseTableView reloadData];
    
    
}

- (void)sendTitle:(NSString *)titleString andTag:(int)_tag{
    isHidden = YES;
    NSLog(@"SPN Item: %@", titleString);
    
    
    switch (_tag) {
        case 0:
            self.title = @"星期一";
            Cday = _tag + 1;
            NSLog(@"----------%d",Cday);
            break;
        case 1:
            self.title = @"星期二";
            Cday = _tag + 1;
            break;
        case 2:
            self.title = @"星期三";
            Cday = _tag + 1;
            break;
        case 3:
            self.title = @"星期四";
            Cday = _tag + 1;
            break;
        case 4:
            self.title = @"星期五";
            Cday = _tag + 1;
            break;
        default:
            break;
    }
    [self reloadViewData];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"课程表";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidAppear:(BOOL)animated{
    
//    [self reloadViewData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arr = [[NSMutableArray alloc] init];
    isHidden = YES;
    getarr = [[Lession alloc] init];
    currentArray = [[NSMutableArray alloc]initWithObjects:@"星期一", @"星期二", @"星期三",@"星期四", @"星期五",nil];
    
    self.view.userInteractionEnabled = YES;
    
    NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps;
	comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
					   fromDate:date];
    
	NSInteger weekday = [comps weekday];
    day = weekday-1;
    if ((day == 0) || (day == 6)) {
        Cday = 1;
    }
    else{Cday = day;}
    NSLog(@"%d",day);
    switch (Cday) {
        case 1:
            self.title = @"星期一";
            break;
        case 2:
            self.title = @"星期二";
            break;
        case 3:
            self.title = @"星期三";
            break;
        case 4:
            self.title = @"星期四";
            break;
        case 5:
            self.title = @"星期五";
            break;
            
        default:
            //self.title = @"周末";
            break;
    }
    
    courseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f) style:UITableViewStyleGrouped];
    courseTableView.delegate = self;
    courseTableView.dataSource = self;
    
    self.courseTableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:courseTableView];
    [self reloadViewData];
    [self showList];
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark
#pragma mark Table view data source

//分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *secHeader = @"";
    
    switch (section) {
        case 0:
            secHeader = @"上午";
            break;
        case 1:
            secHeader = @"下午";
            break;
        case 2:
            secHeader = @"晚上";
            break;
            
        default:
            //secHeader = @"";
            break;
    }
    return secHeader;
}

//组内行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return 1;
    }
    else
        return 0;
}

//行中的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [courseTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 5.0, 70.0, 19.0)];
    label1.textAlignment = UITextAlignmentLeft;
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont fontWithName:@"Ariai" size:10.0];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 5.0, 120.0, 19.0)];
    label2.textAlignment = UITextAlignmentLeft;
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont fontWithName:@"Ariai" size:10.0];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(30.0,27.0, 70.0, 15.0)];
    label3.textAlignment = UITextAlignmentLeft;
    label3.backgroundColor = [UIColor clearColor];
    label3.textColor = [UIColor grayColor];
    label3.font = [UIFont fontWithName:@"Ariai" size:7.0];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 27.0, 140.0, 15.0)];
    label4.backgroundColor = [UIColor clearColor];
    label4.textColor = [UIColor grayColor];
    label4.font = [UIFont fontWithName:@"Ariai" size:7.0];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 5.0, 70.0, 19.0)];
    label5.textAlignment = UITextAlignmentLeft;
    label5.backgroundColor = [UIColor clearColor];
    label5.textColor = [UIColor blackColor];
    label5.font = [UIFont fontWithName:@"Ariai" size:10.0];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 5.0, 120.0, 19.0)];
    label6.textAlignment = UITextAlignmentLeft;
    label6.backgroundColor = [UIColor clearColor];
    label6.textColor = [UIColor blackColor];
    label6.font = [UIFont fontWithName:@"Ariai" size:10.0];
    
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(30.0,27.0, 70.0, 15.0)];
    label7.textAlignment = UITextAlignmentLeft;
    label7.backgroundColor = [UIColor clearColor];
    label7.textColor = [UIColor grayColor];
    label7.font = [UIFont fontWithName:@"Ariai" size:7.0];
    
    UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 27.0, 140.0, 15.0)];
    label8.backgroundColor = [UIColor clearColor];
    label8.textColor = [UIColor grayColor];
    label8.font = [UIFont fontWithName:@"Ariai" size:7.0];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    getarr = [arr objectAtIndex:0];
                    label1.text = getarr.subject;
                    label2.text = getarr.teacher;
                    label3.text = getarr.address;
                    label4.text = getarr.beizhu;
                    
                    [cell addSubview:label1];
                    [cell addSubview:label2];
                    [cell addSubview:label3];
                    [cell addSubview:label4];
                    
                    break;
                case 1:
                    getarr = [arr objectAtIndex:1];
                    NSLog(@"%@```````",getarr.subject);
                    label5.text = getarr.subject;
                    label6.text = getarr.teacher;
                    label7.text = getarr.address;
                    label8.text = getarr.beizhu;
                    [cell addSubview:label5];
                    [cell addSubview:label6];
                    [cell addSubview:label7];
                    [cell addSubview:label8];
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    getarr = [arr objectAtIndex:2];
                    label1.text = getarr.subject;
                    label2.text = getarr.teacher;
                    label3.text = getarr.address;
                    label4.text = getarr.beizhu;
                    [cell addSubview:label1];
                    [cell addSubview:label2];
                    [cell addSubview:label3];
                    [cell addSubview:label4];
                    break;
                case 1:
                    getarr = [arr objectAtIndex:3];
                    label5.text = getarr.subject;
                    label6.text = getarr.teacher;
                    label7.text = getarr.address;
                    label8.text = getarr.beizhu;
                    [cell addSubview:label5];
                    [cell addSubview:label6];
                    [cell addSubview:label7];
                    [cell addSubview:label8];
                    
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    getarr = [arr objectAtIndex:4];
                    label1.text = getarr.subject;
                    label2.text = getarr.teacher;
                    label3.text = getarr.address;
                    label4.text = getarr.beizhu;
                    [cell addSubview:label4];
                    [cell addSubview:label3];
                    [cell addSubview:label2];
                    [cell addSubview:label1];
                    break;
                    
                default:
                    break;
            }
            
        default:
            break;
    }
    
    
    
    [label1 release];
    label1 = nil;
    [label2 release];
    label2 = nil;
    [label3 release];
    label3 = nil;
    [label4 release];
    label4 = nil;
    [label5 release];
    label5 = nil;
    [label6 release];
    label6 = nil;
    [label7 release];
    label7 = nil;
    [label8 release];
    label8 = nil;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{			
    switch (indexPath.section) {
		case 0:
            switch (indexPath.row) {
                case 0:
                    disclosureView = [[DisclosureDetailViewController alloc] init];
                    disclosureView.flag = 0;
                    disclosureView.flagFather = 0;
                    disclosureView.Cday = Cday;
                    disclosureView.delegate = self;
                    [self.navigationController pushViewController:disclosureView animated:YES];
                    break;
                case 1:
                    disclosureView = [[DisclosureDetailViewController alloc] init];
                    disclosureView.flagFather = 0;
                    disclosureView.flag = 1;
                    disclosureView.Cday =Cday;
                    disclosureView.delegate = self;
                    [self.navigationController pushViewController:disclosureView animated:YES];
                    break;
                    
                default:
                    break;
            }
            break;
		case 1:
            switch (indexPath.row) {
                case 0:
                    disclosureView = [[DisclosureDetailViewController alloc] init];
                    disclosureView.flagFather = 1;
                    disclosureView.flag = 2;
                    disclosureView.Cday =Cday;
                    disclosureView.delegate = self;
                    [self.navigationController pushViewController:disclosureView animated:YES];
                    break;
                case 1:
                    disclosureView = [[DisclosureDetailViewController alloc] init];
                    disclosureView.flagFather = 1;
                    disclosureView.flag = 3;
                    disclosureView.Cday =Cday;
                    disclosureView.delegate = self;
                    [self.navigationController pushViewController:disclosureView animated:YES];
                    
                default:
                    break;
            }			
			
			break;
		case 2:
            
            disclosureView = [[DisclosureDetailViewController alloc] init];
            disclosureView.flagFather = 2;
            disclosureView.flag = 4;
            disclosureView.Cday =Cday;
            disclosureView.delegate = self;
            [self.navigationController pushViewController:disclosureView animated:YES];			
            break;
		default:
            break;
	}
    [disclosureView release];
    disclosureView = nil;
}

#pragma delegate
#pragma DisclosureDetailViewController delegate
- (void)passSubject:(NSString *)value1 andTeacher:(NSString *)value2 andAddress:(NSString *)value3 andBeizhu:(NSString *)value4 andFlag:(NSInteger)flag andFlagFather:(NSInteger)flagFather andCday:(NSInteger)Cday{
    
}

- (void)dealloc {
    [arr release];
    arr = nil;
    [spinner release];
    spinner = nil;
    [courseTableView release];
    courseTableView = nil;
    [super dealloc];
    
}

@end
