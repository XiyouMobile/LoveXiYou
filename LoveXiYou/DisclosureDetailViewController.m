//
//  DisclosureDitailViewController.m
//  LoveXiYou
//
//  Created by iphone2 on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DisclosureDetailViewController.h"
#import "UIViewController+AddTitleView.h"
@implementation DisclosureDetailViewController;

@synthesize subjectField;
@synthesize teacherField;
@synthesize addressField;
@synthesize beizhuField;

@synthesize content1;

@synthesize courseBeizhu;
@synthesize courseAddress;
@synthesize courseSubject;
@synthesize courseTeacher;
@synthesize delegate;
@synthesize string;

@synthesize day;
@synthesize Cday;

@synthesize flag;
@synthesize flagFather;




-(IBAction)saveTo:(id)sender{    
    
    if (([subjectField.text length]!=0) && ([addressField.text length] != 0) && ([teacherField.text length] != 0)&& ([beizhuField.text length] != 0) ) {
        PLSqliteDatabase *db=[Database setup];
        
        NSLog(@"Cday:%d",Cday);
        NSString *sql = [NSString stringWithFormat:@"update Lession%d set subject='%@' ,teacher='%@',address='%@' ,beizhu='%@' where number=%d",Cday, subjectField.text,teacherField.text,addressField.text,beizhuField.text,flag ];
        
        
        [db executeUpdate:sql];
        NSLog(@"_______%@",sql);
        [self.navigationController popViewControllerAnimated:YES];
        [delegate reloadViewData];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"保存课表失败" message:@"添加数据不完整" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续编辑", nil];
        
        [alert show];
        [alert release];
        alert = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated{
	self.tableView.backgroundColor = [UIColor clearColor];
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

- (void)viewDidLoad{
    self.title = @"编辑";
	[self setleftBarButtonItem:nil orImaged:@"邮电绿色导航返回按钮" Event:@selector(backTo:)];
    [self setrightBarButtonItem:nil orImaged:@"邮电绿色导航保存按钮" Event:@selector(saveTo:)];


    content1 = [[NSArray alloc] initWithObjects:@"课程",@"老师",@"上课地点",@"备注", nil];
    
    PLSqliteDatabase * db = [Database setup];
    
    NSString * sql = [NSString stringWithFormat:@"select * from Lession%d where number=%d",Cday,flag];
    NSLog(@"-----%@----",sql);
    id<PLResultSet> rs = [db executeQuery:sql];
    while ([rs next])
    {
        self.courseSubject = [rs stringForColumn:@"subject"];
        self.courseTeacher = [rs stringForColumn:@"teacher"];
        self.courseAddress  = [rs stringForColumn:@"address"];
        self.courseBeizhu = [rs stringForColumn:@"beizhu"];
    }
}
- (id)initWithStyle:(UITableViewStyle)style{
	if(self = [super initWithStyle:UITableViewStyleGrouped]){
	}
	return self;
}

- (IBAction)backTo:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)textFieldDoneEditing:(id)sender{
	[sender resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [content1 count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	static NSString *CellIndentifier = @"Details";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
	if(cell == nil)
	{ 
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier] autorelease];
	}
    cell.accessoryView = nil;
    
    NSString *country;
    switch (indexPath.section)
    {
		case 0:
            country = [content1 objectAtIndex:indexPath.row];
			
			break;
		default:
			break;	  
    }
	if ([indexPath section] == 0) 
    {
		switch (indexPath.row) {
			case 0:
				self.subjectField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 190, 34)];
				cell.accessoryView = subjectField;
				//self.subjectField.textAlignment = UITextAlignmentCenter;
				self.subjectField.placeholder = @"type in the subject";
				self.subjectField.text = self.courseSubject;
				self.subjectField.autocapitalizationType = UITextAutocapitalizationTypeWords;
				self.subjectField.borderStyle = UITextBorderStyleRoundedRect;
                self.subjectField.clearButtonMode = UITextFieldViewModeWhileEditing;
				self.subjectField.keyboardType = UIKeyboardTypeDefault;	
				self.subjectField.delegate = self;
				[self.subjectField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
				[cell.contentView addSubview:self.subjectField];
                break;
            case 1:
				self.teacherField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 190, 34)];
				cell.accessoryView = teacherField;
				self.teacherField.placeholder = @"type in the teacher name";
				self.teacherField.text = self.courseTeacher;
				self.teacherField.autocapitalizationType = UITextAutocapitalizationTypeWords;
				self.teacherField.borderStyle = UITextBorderStyleRoundedRect;				
				self.teacherField.keyboardType = UIKeyboardTypeDefault;	
				[self.teacherField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
				[cell.contentView addSubview:self.teacherField];
                break;
            case 2:
                self.addressField = [[UITextField alloc] initWithFrame:CGRectMake(220, 10, 190, 34)];
				cell.accessoryView = addressField;
				self.addressField.placeholder = @"type in the address";
				self.addressField.text = self.courseAddress;
				self.addressField.autocapitalizationType = UITextAutocapitalizationTypeWords;
				self.addressField.borderStyle = UITextBorderStyleRoundedRect;				
				self.addressField.keyboardType = UIKeyboardTypeDefault;	
				[self.addressField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
				[cell.contentView addSubview:self.addressField];
                break;
            case 3:
                self.beizhuField = [[UITextField alloc] initWithFrame:CGRectMake(330, 10, 190, 34)];
				cell.accessoryView = beizhuField;
				self.beizhuField.placeholder = @"type in the beizhu";
				self.beizhuField.text = self.courseBeizhu;
				self.beizhuField.autocapitalizationType = UITextAutocapitalizationTypeWords;
				self.beizhuField.borderStyle = UITextBorderStyleRoundedRect;				
				self.beizhuField.keyboardType = UIKeyboardTypeDefault;	
				[self.beizhuField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
				[cell.contentView addSubview:self.beizhuField];
                break;
            default:
                break;	
        }
    }
    
    cell.textLabel.text = country;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [country release];
	return cell;
}

- (void)passValue:(NSString *)value{
    self.string = [value copy];
}

- (void)viewDidUnload{
	[super viewDidUnload];
	self.subjectField = nil;
	self.addressField = nil;
	self.teacherField = nil;
	self.beizhuField = nil;
	self.content1 = nil;
}

- (void)dealloc{
	[subjectField release];
	[addressField release];
	[teacherField release];
	[beizhuField release];
	
	[content1 release];
	[content2 release];
	[content3 release];
    [content4 release];
	
	[courseSubject release];
	[courseAddress release];
	[courseTeacher release];
	[courseBeizhu release];
	
	[super dealloc];
}



@end