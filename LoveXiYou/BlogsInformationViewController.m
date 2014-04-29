//
//  BlogsInformationViewController.m
//  LoveXiYou
//
//  Created by mobilephone xiyou on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlogsInformationViewController.h"
#import "UIViewController+AddTitleView.h"
#import <QuartzCore/QuartzCore.h>
#import "SinaBlogApp.h"
#import "SVProgressHUD.h"

#define rowsNumber 10

@interface BlogsInformationViewController (private)
-(void)createView;
//-(void)refreshView;
@end

@implementation BlogsInformationViewController
@synthesize commentTableView;
@synthesize iconImageView;
@synthesize nameLabel;
@synthesize introTextView;
@synthesize followButton;
@synthesize SubmissionButton;

@synthesize blogTextView;
@synthesize commentBut;
@synthesize forwardBut;
@synthesize collectionBut;
@synthesize blogContext;
@synthesize weibo_ID;
@synthesize weibo_Name;

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
    [commentTableView release],commentTableView = nil;
    
    [iconImageView release],iconImageView = nil;
    [nameLabel release],nameLabel = nil;
    [introTextView release],introTextView = nil;
    [followButton release],followButton = nil;
    [SubmissionButton release],SubmissionButton = nil;
    
    [blogBackView release],blogBackView = nil;
    [blogTextView release], blogTextView = nil;
    [commentBut release],commentBut = nil;
    [forwardBut release],forwardBut = nil;
    [collectionBut release],collectionBut = nil;
    [blogContext release],blogContext = nil;
    [engine setDelegate:nil];
    [engine release],engine = nil;
    [userDict release],userDict = nil;
    /*if (weibo_Name) {
        [weibo_Name release],weibo_Name = nil;
    }*/
    [weibo_ID release],weibo_ID = nil;
    [commentList release],commentList = nil;
}

//初始化App信息
- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret 
{
    if (self = [super init])
    {  
        appKey = [theAppKey retain];
        appSecret = [theAppSecret retain];
        engine = [[WBEngine alloc] initWithAppKey:appKey appSecret:appSecret];
        [engine setDelegate:self];
        
        commentList = [[NSMutableArray alloc] init];
        userDict = [[NSDictionary alloc] init];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //加载按钮
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航返回按钮" Event:@selector(backTo:)];
    //[self setrightBarButtonItem:@"私信" orImaged:nil Event:@selector(SubmissionButPressed:)];
    [self setrightBarButtonItem:nil orImaged:@"邮电绿色导航倾诉按钮" Event:@selector(SubmissionButPressed:)];

    SubmissionButton.tag = 102;

    collectionBut.tag = 105;
    
    commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(20.0f, 260.0f, 280.0f, 107.0f) style:UITableViewStylePlain];
    commentTableView.backgroundColor = [UIColor clearColor];
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    [self.view addSubview:commentTableView];
    [self getCommentList];//获取评论表单
    
    self.nameLabel.text = [NSString stringWithFormat:@"微博名称"];
    self.nameLabel.textAlignment = UITextAlignmentCenter;
    
    self.introTextView.text = [NSString stringWithFormat:@"微博介绍"];
    self.introTextView.textAlignment = UITextAlignmentCenter;
    
    blogBackView.image = [UIImage imageNamed:@"邮电绿色文本框"];
    
    blogTextView.text = [NSString stringWithFormat:@"微博内容"];
    blogTextView.textAlignment = UITextAlignmentCenter;
    
}

//获取评论的返回信息
- (void)getCommentList{
    cFlag = 300;
    NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",weibo_ID], @"id",@"10",@"count",nil];
    [engine loadRequestWithMethodName:@"comments/show.json" 
                           httpMethod:@"GET" 
                               params:myDict 
                         postDataType:kWBRequestPostDataTypeNormal 
                     httpHeaderFields:nil];
    [myDict release];
    myDict = nil;
}

//获取用户信息
- (void)userMessage{
    uFlag = 200;
    NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",weibo_Name],@"screen_name", nil];
    [engine loadRequestWithMethodName:@"users/show.json" httpMethod:@"GET" params:myDict postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
    [myDict release];
    myDict = nil;
}

//加载完成后数据显示
#pragma mark - private Methods
-(void)createView{
    
    if ([[userDict objectForKey:@"following"] intValue] == 1) {
    
        [followButton setImage:[UIImage imageNamed:@"邮电绿色按钮背景图_取消关注"] forState:UIControlStateNormal];
        followButton.tag = 100;
    }else{
        [followButton setImage:[UIImage imageNamed:@"邮电绿色加关注"] forState:UIControlStateNormal];
      followButton.tag = 101;
    }
    
    [self.nameLabel setText:[userDict objectForKey:@"screen_name"]];
    self.nameLabel.textAlignment = UITextAlignmentCenter;
   
    introTextView.delegate = self;
    introTextView.text = [userDict objectForKey:@"description"];
    introTextView.textAlignment = UITextAlignmentCenter;
    introTextView.font = [UIFont systemFontOfSize:12.0];
    introTextView.keyboardAppearance = NO;
    
    //微博内容
    blogTextView.delegate = self;
    blogTextView.layer.cornerRadius = 6.0; 
    blogTextView.layer.borderWidth = 0;
    blogTextView.text = blogContext;
    [blogTextView setFont:[UIFont systemFontOfSize:12.0f]]; 
    blogTextView.enablesReturnKeyAutomatically = NO;
    blogTextView.keyboardAppearance = NO;
    
    NSURL *url = [NSURL URLWithString:[userDict objectForKey:@"avatar_large"]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    [iconImageView setImage:image];
}

//返回
- (void)backTo:(id)sender{
  [self.navigationController popViewControllerAnimated:YES];
}

//关注
- (void)addFollowed:(NSString *)_name{
    NSDictionary *tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:_name,@"screen_name",nil];
    [engine loadRequestWithMethodName:@"friendships/create.json" httpMethod:@"POST" params:tempDict postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
    [tempDict release];
    tempDict = nil;
}
//取消关注
- (void)destoryFollowed:(NSString *)_name{
   NSDictionary *tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:_name, @"screen_name",nil];
    [engine loadRequestWithMethodName:@"friendships/destroy.json"
                           httpMethod:@"POST"
                               params:tempDict
                         postDataType:kWBRequestPostDataTypeNormal
                     httpHeaderFields:nil];
    [tempDict release];
    tempDict = nil;
}

//是否关注
- (IBAction)isFollowed:(id)sender{
    UIButton *but = (UIButton *)sender;
    engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setRootViewController:self];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    
    if ([engine isLoggedIn] && ![engine isAuthorizeExpired]) {
        if (but.tag == 100) {
            alertMessage = @"取消关注";
            [self destoryFollowed:weibo_Name];
            //[self addFollowed:weibo_Name];
            followButton.tag = 101;
            [followButton setImage:[UIImage imageNamed:@"邮电绿色加关注"] forState:UIControlStateNormal];
        }else if(but.tag == 101){
            alertMessage= @"加关注";
            [self addFollowed:weibo_Name];
            //[self destoryFollowed:weibo_Name];
            followButton.tag = 100;
            [followButton setImage:[UIImage imageNamed:@"邮电绿色按钮背景图_取消关注"] forState:UIControlStateNormal];
        }
    }else {
        [self loginOn];
    }
}

//登陆微博
- (void)loginOn{
    
    [self performSelector:@selector(onLogInOAuthButtonPressed) withObject:nil afterDelay:0.0];
}

- (void)onLogInOAuthButtonPressed{
    [engine logIn];
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
}

//登录失败
- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
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

//投稿,发私信
- (IBAction)SubmissionButPressed:(id)sender{
    BlogSendViewController *sendView = [[BlogSendViewController alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:[NSString stringWithFormat:@"对@%@ 说：",nameLabel.text]];
    sendView.weibo_ID = weibo_ID;
    [sendView setDelegate:self];
    sendView.tag = 102;
    buttonTag = 102;
    [sendView show:YES];
    [sendView release];
    sendView = nil;
}

//发送评论
- (IBAction)commentButPressed:(id)sender{
    commentBut.tag = 103;
    buttonTag = 103;
    BlogSendViewController *sendView = [[BlogSendViewController alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:@"test"];
    sendView.weibo_ID = weibo_ID;
    [sendView setDelegate:self];
    sendView.tag = commentBut.tag;
    [sendView show:YES];
    [sendView release];
    sendView = nil;
}

//转发
- (IBAction)forwardButPressed:(id)sender{
    forwardBut.tag = 104;
    buttonTag = 104;
    BlogSendViewController *sendView = [[BlogSendViewController alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:@"test"];
    sendView.weibo_ID = weibo_ID;
    [sendView setDelegate:self];
    sendView.tag = forwardBut.tag;
    sendView.blogContext = blogContext;
    [sendView show:YES];
    [sendView release];
    sendView = nil;
}

//是否收藏
- (void)isCollected:(NSString *)_ID{
    
    NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",weibo_ID],@"id",nil];
    [engine loadRequestWithMethodName:@"favorites/create.json" httpMethod:@"POST" params:myDict postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
    [myDict release];
    myDict = nil;
}
- (void)destoryCollected:(NSString *)_ID{
    
    NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",weibo_ID],@"id",nil];
    [engine loadRequestWithMethodName:@"favorites/destory.json" httpMethod:@"POST" params:myDict postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
    [myDict release];
    myDict = nil;
}

//收藏
- (IBAction)collectButPressed:(id)sender{
   alertMessage = @"收藏";
    NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",weibo_ID],@"id",nil];
    [engine loadRequestWithMethodName:@"favorites/create.json" httpMethod:@"POST" params:myDict postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
    [myDict release];    
    myDict = nil;
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

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [commentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [commentTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *detail = [commentList objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[[detail objectForKey:@"user"] objectForKey:@"profile_image_url"]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    cell.imageView.image = image;  
    
    cell.textLabel.text = [[detail objectForKey:@"user"] objectForKey:@"screen_name"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16.0f]];
    cell.detailTextLabel.text = [detail objectForKey:@"text"];
    [cell.detailTextLabel setNumberOfLines:2];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12.0f]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)actionAlert:(id)sender{
    UIButton *but = (UIButton *)sender;
    if (but.tag == 100) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息" message:[NSString stringWithFormat:@"%@成功",alertMessage] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release]; 
        alert = nil;
    }    
}

#pragma mark - WBEngineDelegate Methods
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    [SVProgressHUD dismiss];
    if (cFlag == 300) {
    if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)result;
            [commentList addObjectsFromArray:[dict objectForKey:@"comments"]];//按照键值对应将微博存入数组
            NSLog(@"11:%d",commentList.count);
            [commentTableView reloadData]; 
          }
           cFlag = 0;
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(userMessage) userInfo:nil repeats:NO];
        }else if(uFlag == 200){
            if ([result isKindOfClass:[NSDictionary class]]) {       
                userDict = [(NSDictionary *)result retain];
                [self createView];
            }
            uFlag = 0;
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息" message:[NSString stringWithFormat:@"%@成功",alertMessage] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [alert release]; 
            alert = nil;
        }
}

//请求失败
- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    
    UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"%@失败",alertMessage] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [myAlert show];
    [myAlert release];
    myAlert = nil;
}


#pragma mark - WBSendViewDelegate Methods

- (void)sendViewDidFinishSending:(BlogSendViewController *)view
{
    [view hide:YES];
    NSString *message = nil;
    switch (buttonTag) {
        case 102:
            message = @"微博发送成功！";
            break;
        case 103:
            message = @"微博评论成功！";
            break;
        case 104:
            message = @"微博转发成功！";
            break;
        default:
            break;
    }
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
													   message:@"微博转发失败！" 
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

@end
