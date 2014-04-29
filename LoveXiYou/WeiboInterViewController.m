//
//  WeiboInterViewController.m
//  LoveXiYou
//
//  Created by mobilephone xiyou on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WeiboInterViewController.h"
#import "SinaBlogApp.h"

@implementation WeiboInterViewController
@synthesize blogEngine;
@synthesize indicatorView;

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret{
    if (self = [super init]) {
        appKey = [theAppKey retain];
        appSecret = [theAppSecret retain];
        
        blogEngine = [[WBEngine alloc] initWithAppKey:appKey appSecret:appSecret];
        [blogEngine setDelegate:self];
        
        blogList = [[NSMutableArray alloc] init];
        userList = [[NSMutableArray alloc] init];
    }
    return self;
}

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
    [blogEngine release];
    blogEngine = nil;
    [indicatorView release];
    indicatorView = nil;
    [blogList release];
    blogList = nil;
    [userList release];
    userList = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
}

//更新时间轴
- (void)refreshTimeline{
    [blogEngine loadRequestWithMethodName:@"statuses/home_timeline.json"
                               httpMethod:@"GET"
                                   params:nil
                             postDataType:kWBRequestPostDataTypeNone
                         httpHeaderFields:nil];
}

//登陆微博
- (void)loginOn:(id)sender{
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setRootViewController:self];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    self.blogEngine = engine;
    [engine release];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setCenter:CGPointMake(160, 240)];
    [self.view addSubview:indicatorView];
    
    if ([blogEngine isLoggedIn] && ![blogEngine isAuthorizeExpired]) {
        [self performSelector:@selector(onLogInOAuthButtonPressed) withObject:nil afterDelay:0.0];
    }else{
        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(talkTo:) userInfo:nil repeats:NO];
    }
}

#pragma mark - User Actions
- (void)onLogInOAuthButtonPressed{
    [blogEngine logIn];
}

- (void)onLogOutButtonPressed{
    [blogEngine logOut];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Authorize
- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    [indicatorView stopAnimating];
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"请先登出！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        alertView = nil;
    }
}

//登陆成功
- (void)engineDidLogIn:(WBEngine *)engine
{
    [indicatorView stopAnimating];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    alertView = nil;
}

//登录失败
- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    [indicatorView stopAnimating];
    //NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    alertView = nil;
}

//登出成功
- (void)engineDidLogOut:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登出成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    alertView = nil;
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

//重新登陆
- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"请重新登录！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    alertView = nil;
}

//获取微博评论列表
- (void)commentList:(NSString *)weiboID{
    NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",weiboID], @"id",nil];
    alertMessage = @"评论列表获取";
    [blogEngine loadRequestWithMethodName:@"comments/show.json" 
                           httpMethod:@"GET" 
                               params:myDict 
                         postDataType:kWBRequestPostDataTypeNormal 
                     httpHeaderFields:nil];
    [myDict release];
    myDict = nil;
}

//取消关注
- (void)cancelFollow:(NSString *)screenName{
    NSDictionary *tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:screenName, @"screen_name",nil];
    alertMessage = @"取消关注";
    [blogEngine loadRequestWithMethodName:@"friendships/destroy.json"
                           httpMethod:@"POST"
                               params:tempDict
                         postDataType:kWBRequestPostDataTypeNormal
                     httpHeaderFields:nil];
    [tempDict release];
    tempDict = nil;
}

//关注
- (void)followButton:(NSString *)screenName{
    NSDictionary *tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:screenName, @"screen_name",nil];
    alertMessage = @"关注";
    [blogEngine loadRequestWithMethodName:@"friendships/create.json" httpMethod:@"POST" params:tempDict postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
    [tempDict release];
    tempDict = nil;
}

//评论
- (void)commentButton:(NSString *)weiboID addContext:(NSString *)context{
    
    NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",weiboID],@"id",context,@"comment", nil];
    alertMessage = @"评论";
    [blogEngine loadRequestWithMethodName:@"comments/create.json" httpMethod:@"POST" params:myDict postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
    [myDict release];
    myDict = nil;
}

//转发
- (void)forwardButton:(NSString *)weiboID addContext:(NSString *)context{
    //将其根据键值打包存入字典，并进行转发请求
    NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",weiboID],@"id",context,@"status", nil];
    alertMessage = @"转发";
    [blogEngine  loadRequestWithMethodName:@"statuses/repost.json" 
                            httpMethod:@"POST" 
                                params:myDict
                          postDataType:kWBRequestPostDataTypeNormal 
                      httpHeaderFields:nil];
    [myDict release];
    myDict = nil;
}

//收藏
- (void)collectButton:(NSString *)weiboID{
    NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",weiboID],@"id",nil];
    alertMessage = @"收藏";
    [blogEngine loadRequestWithMethodName:@"favorites/create.json" httpMethod:@"POST" params:myDict postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
    [myDict release];
    myDict = nil;
    
}

#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    [indicatorView stopAnimating];
    NSLog(@"RESULT:%@",result);
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        [blogList addObjectsFromArray:[dict objectForKey:@"statuses"]];
        //[blogTableView reloadData];
        [commentList addObjectsFromArray:[dict objectForKey:@"comments"]];//按照键值对应将微博存入数组
        //[commentTableView reloadData];        
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息" message:[NSString stringWithFormat:@"%@成功",alertMessage] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
    alert = nil;
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    [indicatorView stopAnimating];
    
    UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"%@失败",alertMessage] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [myAlert show];
    [myAlert release];    
    myAlert = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    indicatorView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
