//
//  DetailBlogViewController.m
//  LoveXiYou
//
//  Created by mobilephone xiyou on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailBlogViewController.h"
#import "SinaBlogApp.h"
#import "UIViewController+AddTitleView.h"
#import "SVProgressHUD.h"

@implementation DetailBlogViewController

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

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret
{
    if (self = [super init])
    {  NSLog(@"1111");
        appKey = [theAppKey retain];
        appSecret = [theAppSecret retain];
        
        blogEngine = [[WBEngine alloc] initWithAppKey:appKey appSecret:appSecret];
        [blogEngine setDelegate:self];
        
        weiBoList = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)dealloc
{
    
    [appKey release], appKey = nil;
    [appSecret release], appSecret = nil;
    
    [blogEngine setDelegate:nil];
    [blogEngine release], blogEngine = nil;
    
    [weiBoTableView setDataSource:nil];
    [weiBoTableView setDelegate:nil];
    [weiBoTableView release],weiBoTableView = nil;
    
    [weiBoList release],weiBoList = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航返回按钮" Event:@selector(backTo:)];
    [self setrightBarButtonItem:nil orImaged:@"邮电绿色导航倾诉按钮" Event:@selector(SubmissionButPressed:)];
    
    weiBoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f) style:UITableViewStylePlain];
    weiBoTableView.delegate = self;
    weiBoTableView.dataSource = self;
    [self.view addSubview:weiBoTableView];
    NSLog(@"22222");
    blogEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [blogEngine setRootViewController:self];
    [blogEngine setDelegate:self];
    [blogEngine setRedirectURI:@"http://"];
    [blogEngine setIsUserExclusive:NO];
    
    if ([blogEngine isLoggedIn] && ![blogEngine isAuthorizeExpired]) {
        
        NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:self.title,@"screen_name", nil];
        
        [blogEngine loadRequestWithMethodName:@"statuses/user_timeline.json" 
                               httpMethod:@"GET" 
                                   params:myDict 
                             postDataType:kWBRequestPostDataTypeNormal 
                         httpHeaderFields:nil];
    }else {
        [self loginOn];
    }
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
}

//登陆微博
- (void)loginOn{
    [self performSelector:@selector(onLogInOAuthButtonPressed) withObject:nil afterDelay:0.0];
}

- (void)onLogInOAuthButtonPressed{
    [blogEngine logIn];
}

//登陆成功
- (void)engineDidLogIn:(WBEngine *)engine
{
    [SVProgressHUD dismiss];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    alertView = nil;
    
    NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:self.title,@"screen_name", nil];
    
    [blogEngine loadRequestWithMethodName:@"statuses/user_timeline.json" 
                           httpMethod:@"GET" 
                               params:myDict 
                         postDataType:kWBRequestPostDataTypeNormal 
                     httpHeaderFields:nil];
}

//登录失败
- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    alertView = nil;
}


//返回
- (void)backTo:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//投稿,发私信
- (IBAction)SubmissionButPressed:(id)sender{
    BlogSendViewController *sendView = [[BlogSendViewController alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:[NSString stringWithFormat:@"对@%@ 说：",self.title]];
    //sendView.weibo_ID = weibo_ID;
    [sendView setDelegate:self];
    [sendView show:YES];
    [sendView release];
    sendView = nil;
}

#pragma mark - WBSendViewDelegate Methods

- (void)sendViewDidFinishSending:(BlogSendViewController *)view
{
    [view hide:YES];
    NSString *message = @"微博发送成功";
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:message
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    alertView = nil;
}

- (void)sendView:(BlogSendViewController *)view didFailWithError:(NSError *)error
{
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    alertView = nil;
}

- (void)sendViewNotAuthorized:(BlogSendViewController *)view
{
    [view hide:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendViewAuthorizeExpired:(BlogSendViewController *)view
{
    [view hide:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [weiBoTableView setDelegate:nil];
    [weiBoTableView setDataSource:nil];
    [weiBoTableView release], weiBoTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    BOOL hasStatusBar = ![UIApplication sharedApplication].statusBarHidden;
    int height = (hasStatusBar) ? 20 : 0;
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        [weiBoTableView setFrame:CGRectMake(0, 0, 480, 320 - height - 32)];
    }
    else
    {
        [weiBoTableView setFrame:CGRectMake(0, 0, 320, 480 - height - 44)];
    }
}
#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [weiBoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Timeline Cell"];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Timeline Cell"] autorelease];
    }
    
    NSDictionary *detail = [weiBoList objectAtIndex:indexPath.row];
    [cell.textLabel setText:[detail objectForKey:@"text"]];
    [cell.textLabel setNumberOfLines:2];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回当前选择行的微博文字和微博id，传值并进入下级界面
    NSDictionary *det = [weiBoList objectAtIndex:indexPath.row];
   BlogsInformationViewController *blogDetailView = [[BlogsInformationViewController alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    blogDetailView.weibo_ID = [det objectForKey:@"id"];
    blogDetailView.blogContext = [det objectForKey:@"text"];
    blogDetailView.weibo_Name = [[det objectForKey:@"user"] objectForKey:@"screen_name"];
    
    blogDetailView.title = [[det objectForKey:@"user"] objectForKey:@"screen_name"];
    [self.navigationController pushViewController:blogDetailView animated:YES];
    [blogDetailView release];
    blogDetailView = nil;
}

#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    [SVProgressHUD dismiss];
    if ([result isKindOfClass:[NSDictionary class]])
    {
      NSDictionary *dict = (NSDictionary *)result;
      [weiBoList addObjectsFromArray:[dict objectForKey:@"statuses"]];      //按照键值对应将微博存入数组
      [weiBoTableView reloadData];
    }
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"requestDidFailWithError: %@", error);
}
@end
