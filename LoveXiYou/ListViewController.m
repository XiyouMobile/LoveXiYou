//
//  ListViewController.m
//  LoveXiYou
//
//  Created by  on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"
#import "UIViewController+AddTitleView.h"

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithViewTag:(int)_viewTag{
    self = [super init];
    if (self) {
        
        
        
        introductionArr = [NSMutableArray arrayWithObjects:@"西邮概况",@"人才培养",@"西邮通讯录", nil];
        
        partArray = [NSMutableArray arrayWithObjects:@"计算机学院", @"通信工程学院", @"电子工程学院", @"自动化学院", @"经济与管理学院", @"理学院",@"管理与工程学院",@"人文社科学院",@"外语系",@"数字媒体艺术系",@"继职学院",@"体育部",@"物两研究院",@"马克思主义研究院",@"国防教育学院",nil];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Mail" ofType:@"plist"];
        dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSLog(@"dict:%@",dict);
        
        keys = [[NSArray alloc] initWithArray:[[dict allKeys] sortedArrayUsingSelector:@selector(compare:)]];
        NSLog(@"keys:%@",keys);
        
        mailArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0; i < [keys count]; i++) {
            [mailArray addObject:[dict objectForKey:[keys objectAtIndex:i]]];
        }
        
        mailArr = [[NSArray alloc] initWithArray:mailArray];
        NSLog(@"mailArr:%@",mailArr);
        
        mailResultArr = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0; i < [mailArr count]; i++) {
            if ([[mailArr objectAtIndex:i] count] > 0) {
                NSLog(@"count:%d",[[mailArr objectAtIndex:i] count]);
                for (int j = 0; j < [[mailArr objectAtIndex:i] count]; j++) {
                    [mailResultArr addObject:[[mailArr objectAtIndex:i] objectAtIndex:j]];
                }
                
            }
        }
        mailResultArray = [[NSArray alloc] initWithArray:mailResultArr];
        NSLog(@"mailResultArray:%@",mailResultArray);
        
        
        [self showList:_viewTag];
        
    }
    return  self;
}

- (void)compare:(id)inObject{
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc{
    [mailListTable release];
    mailListTable = nil;
    [mailArr release];
    mailArr = nil;
    [mailResultArr release];
    mailResultArr = nil;
    [mailResultArray release];
    mailResultArray = nil;
    [keys release];
    keys = nil;
    [mailArray release];
    mailArray = nil;
    [dict release];
    dict = nil;
    //[spinner release];
    //spinner = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    isHidden = YES;
    [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航返回按钮" Event:@selector(backTo:)];
    
}

//从tag值判断是西邮简介还是院系列表，显示响应界面
- (void)showList:(int)_viewTag{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resPath = [bundle resourcePath];
    
    NSString *filePath = nil;
    viewTag = _viewTag;
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    switch (_viewTag) {
        case 101:
            [self setrightBarButtonItem:nil orImaged:@"邮电绿色导航新窗口按钮" Event:@selector(listTo:)];
            spinner = [[Spinner alloc] initWithFrame:CGRectMake(0, 0, 300, 352) data:introductionArr view:self.view];
            spinner.delegate = self;
            NSLog(@"SPN Item: %@", spinner.title);
            self.title = @"西邮概况";
            
            filePath = [resPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.html",[introductionArr objectAtIndex:0]]];
            
            break;
        case 102:
            [self setrightBarButtonItem:nil orImaged:@"邮电绿色导航新窗口按钮" Event:@selector(listTo:)];
            spinner = [[Spinner alloc] initWithFrame:CGRectMake(0, 0, 300, 352) data:partArray view:self.view];
            spinner.delegate = self;
            NSLog(@"SPN Item: %@", spinner.title);
            
            self.title = @"计算机学院";
            
            filePath = [resPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.html",[partArray objectAtIndex:0]]];
            
            break; 
        default:
            break;
    }
    
    [webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]
                    baseURL:[NSURL fileURLWithPath:[bundle bundlePath]]];
    [self.view addSubview:webView];
    [webView release];
    webView = nil;
    
    [SVProgressHUD dismiss];
    
    //spinner.delegate = self;
    
	//[self.view addSubview:spinner];
    //[spinner release];
}

//返回首页
- (void)backTo:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//列表按钮响应事件，点击显示响应列表视图
- (void)listTo:(id)sender{

    if (isHidden == YES) {
        isHidden = NO;
        [spinner showList];
        
    }else {
        [spinner hiddenView];
        isHidden = YES;
    }
    
}

#pragma delegate
#pragma spinnerDelegate
- (void)sendTitle:(NSString *)titleString andTag:(int)_tag{
    
    isHidden = YES;
    
    NSLog(@"SPN Item: %@", titleString);
    self.title = titleString;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resPath = [bundle resourcePath];
    
    NSString *filePath = nil;
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    
    switch (viewTag) {
        case 101:
            if (_tag < 2) {
                
                filePath = [resPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.html",[introductionArr objectAtIndex:_tag]]];
                
                [webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]
                                baseURL:[NSURL fileURLWithPath:[bundle bundlePath]]];
                [self.view addSubview:webView];
                [webView release];
                webView = nil;
                
            }
            if (_tag == 2) {
                NSLog(@"通讯录");
                
                mailListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
                mailListTable.backgroundColor = [UIColor whiteColor];
                mailListTable.delegate = self;
                mailListTable.dataSource = self;
                self.view.backgroundColor = [UIColor whiteColor];
                [self.view addSubview:mailListTable];
            }
            break;
        case 102:
            filePath = [resPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.html",[partArray objectAtIndex:_tag]]];
            
            [webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]
                            baseURL:[NSURL fileURLWithPath:[bundle bundlePath]]];
            [self.view addSubview:webView];
            [webView release];
            webView = nil;
            break;
        default:
            break;
    }
    
    [SVProgressHUD dismiss];
    
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [mailResultArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dictionary = [mailResultArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"phone"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSArray *array = [[mailResultArray objectAtIndex:indexPath.row] objectForKey:@"phone"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cellValue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *headerTitle = [NSString stringWithFormat:@"%@",[[mailResultArray objectAtIndex:section] objectForKey:@"name"]];
    return headerTitle;
}

//添加索引的值，为右侧的A----Z 
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView  
{  
    return nil;
    //return keys; 
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

@end
