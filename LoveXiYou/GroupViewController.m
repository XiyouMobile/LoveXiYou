//
//  GroupViewController.m
//  LoveXiYou
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GroupViewController.h"
#import "UIViewController+AddTitleView.h"
#import "SinaBlogApp.h"
#import "ModalAlert.h"
#import "SVProgressHUD.h"

static int userCount;
static int count = 0;

@interface GroupViewController (Private)

- (void)dismissTimelineViewController;
- (void)presentTimelineViewController:(BOOL)animated;
- (void)presentTimelineViewControllerWithoutAnimation;
@end

@implementation GroupViewController
@synthesize blogTableView;
@synthesize blogEngie;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"校园";
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
    
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setRootViewController:self];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    self.blogEngie = engine;
    [engine release];
    
    if ([blogEngie isLoggedIn] && ![blogEngie isAuthorizeExpired]) {
        NSLog(@"userID=%@,accessToken=%@,expireTime=%f",blogEngie.userID,blogEngie.accessToken,blogEngie.expireTime);
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
        
        [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航登出按钮" Event:@selector(loginOut:)];
        [self refreshTimeline];
        
    }else{
        
        blogList = nil;
        [blogTableView reloadData];
        
        [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航登入按钮" Event:@selector(loginOn)]; 
    }
}

- (void)dealloc{
    [super dealloc];
    [blogTableView release];
    [blogEngie release];
}


- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret
{
    if (self = [super init])
    {  
        appKey = [theAppKey retain];
        appSecret = [theAppSecret retain];
        
        blogEngie = [[WBEngine alloc] initWithAppKey:appKey appSecret:appSecret];
        [blogEngie setDelegate:self];
        
        blogList = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)refreshTimeline
{   
    [blogEngie loadRequestWithMethodName:@"statuses/home_timeline.json"
                           httpMethod:@"GET"
                               params:nil
                         postDataType:kWBRequestPostDataTypeNone
                     httpHeaderFields:nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isHidden = YES;
    [self setrightBarButtonItem:nil orImaged:@"邮电绿色导航新窗口按钮" Event:@selector(talkTo:)];
    
    /*WBEngine *engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setRootViewController:self];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    self.blogEngie = engine;
    [engine release];
    
    if ([blogEngie isLoggedIn] && ![blogEngie isAuthorizeExpired]) {
        
        [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航登出按钮" Event:@selector(loginOut:)];
        //[self refreshTimeline];
        
    }else{
        
        [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航登入按钮" Event:@selector(loginOn)]; 
    }*/
    
    userList = [[NSMutableArray alloc] initWithObjects:@"西邮微博协会",@"西邮校园",@"西邮男女", nil]; 
    userCount = [userList count];
    
    blogTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f) style:UITableViewStylePlain];
    blogTableView.backgroundColor = [UIColor clearColor];
    blogTableView.delegate = self;
    blogTableView.dataSource = self;
    [self.view addSubview:blogTableView];
    
    blogArray = [NSMutableArray arrayWithObjects:@"西邮微博协会",@"西安邮电大学",@"西邮校园",@"西邮男女",@"西邮人",@"在西邮",@"西邮那些事儿",@"聚焦西邮",@"西邮真相",@"西邮就业指导中心",   @"西安邮电大学校学生会",@"西邮校学生会老校区",@"西邮校学生会宣传部",@"西邮校团委学生会团总支",@"西安邮电大学团委",@"西邮校青年志愿者协会",@"西邮校青协老校区",   @"西邮电院学生会",@"西邮自动化学院学生会",@"西邮管工院学生会",@"西邮人文院学生会",  @"西邮计算机学院分团委学生会",@"西邮自动化学院分团委",@"西邮管工院分团委",@"西邮经管院分团委学生会",@"西邮人文社科学院分团委",@"西邮数媒系团总支",@"西邮继职学院分团委学生会",@"西邮研究生部分团委",   @"西邮理学院志愿者协会",   @"西邮移动应用开发俱乐部", @"西邮Linux兴趣小组",  @"西安邮电大学招生办公室",   @"西邮社团联合会",@"西邮校报记者",@"西邮BBS",@"西邮大学生记者团",@"西邮大学生记者团后援",@"西邮广播企宣部",@"西邮FM866",@"西邮图管会",@"西邮DIY",@"西邮影视协会",@"西邮影协",@"西邮乒协",@"西邮绿园文学社",@"西邮MT音乐俱乐部",@"西邮FTF桌游社",@"西邮绿色环协",@"西邮历史协会",@"西邮老校区红凤社",@"西安邮电大学足球协会",@"西邮法律爱好者协会",@"西邮商务策划协会",@"西邮Lamo拉丁舞社",@"西邮idea精英汇",@"西邮研究生会",@"西邮零距离协会",@"西安邮电大学网球俱乐部",nil];
    [self initShowList];
    
    //[self refreshTimeline];
}

- (void)initShowList{
    spinner = [[Spinner alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 352.0f) data:blogArray view:self.view];
    spinner.delegate = self;
}

//倾诉功能
- (void)talkTo:(id)sender{
    [MobClick event:@"倾诉"];
    if (isHidden == YES) {
        [spinner showList];
        isHidden = NO;
    }else {
        [spinner hiddenView];
        isHidden = YES;
    }
}

- (void)sendTitle:(NSString *)titleString andTag:(int)_tag{
    
    isHidden = YES;
    
    if (![CloNetworkUtil getNetWorkStatus]) {
        [ModalAlert say:@"未连接网络\n请稍检查您的网络设置..."];
    }else {
        DetailBlogViewController *detailViewLast = [[DetailBlogViewController alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        detailViewLast.title = titleString;
        [self.navigationController pushViewController:detailViewLast animated:YES];
        [detailViewLast release];
    }
}

#pragma mark - User Actions
-(void)loginOn{
    if (![CloNetworkUtil getNetWorkStatus]) {
        [ModalAlert say:@"未连接网络\n请稍检查您的网络设置..."];
    }else {
        [blogEngie logIn];
    }
}

- (void)loginOut:(id)sender{
    [MobClick event:@"登录"];
    if (![CloNetworkUtil getNetWorkStatus]) {
        [ModalAlert say:@"未连接网络\n请稍检查您的网络设置..."];
    }else {
        [blogEngie logOut]; 
    }
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kWBAlertViewLogInTag)
    {
        //[self setleftBarButtonItem:@"登出" orImaged:nil Event:@selector(loginOut:)];
        [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航登出按钮" Event:@selector(loginOut:)];
        
    }
    else if (alertView.tag == kWBAlertViewLogOutTag)
    {
        [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航登入按钮" Event:@selector(loginOn)];
    }
}

#pragma mark - WBLogInAlertViewDelegate Methods
- (void)logInAlertView:(WBLogInAlertView *)alertView logInWithUserID:(NSString *)userID password:(NSString *)password
{
    [blogEngie logInUsingUserID:userID password:password];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
}

#pragma mark - WBEngineDelegate Methods

#pragma mark Authorize
- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"请先登出！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogInTag];
	[alertView show];
	[alertView release];
    [self refreshTimeline];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登出成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogOutTag];
	[alertView show];
	[alertView release];
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"请重新登录！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

#pragma mark -
#pragma mark loginOn delegate

- (void)getBlogMessage{
    NSLog(@"读出信息");
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:[NSString stringWithFormat:@"%@",[userList objectAtIndex:count]] forKey:@"screen_name"];
    [blogEngie loadRequestWithMethodName:@"users/show.json"
                           httpMethod:@"GET"
                               params:params
                         postDataType:kWBRequestPostDataTypeNone
                     httpHeaderFields:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [blogTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *detail = [blogList objectAtIndex:indexPath.row]; 
    [cell.textLabel setText:[[detail objectForKey:@"user"] objectForKey:@"screen_name"]];
    [cell.detailTextLabel setText:[detail objectForKey:@"text"]];
    [cell.detailTextLabel setNumberOfLines:2];
    
    //头像获取
//    NSURL *url = [NSURL URLWithString:[detail objectForKey:@"profile_image_url"]];
//    NSData *imageData = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [UIImage imageWithData:imageData];
//    cell.imageView.image = image;
//    
//    //微博内容
//    [cell.textLabel setText:[detail objectForKey:@"screen_name"]];
//    [cell.detailTextLabel setText:[[detail objectForKey:@"status"] objectForKey:@"text"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    
    cell.editingAccessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    NSDictionary *det = [blogList objectAtIndex:indexPath.row];
    if ([blogEngie isLoggedIn] && ![blogEngie isAuthorizeExpired]) {
        BlogsInformationViewController *blogDetailView = [[BlogsInformationViewController alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        blogDetailView.weibo_ID = [det objectForKey:@"id"];
        blogDetailView.blogContext = [det objectForKey:@"text"];
        blogDetailView.weibo_Name = [[det objectForKey:@"user"] objectForKey:@"screen_name"];
        blogDetailView.title = [[det objectForKey:@"user"] objectForKey:@"screen_name"];
        [self.navigationController pushViewController:blogDetailView animated:YES];
        [blogDetailView release];
    }else {
        [self loginOn];
    }
}

#pragma mark - WBEngineDelegate Methods
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result{
    
    [SVProgressHUD dismiss];
    blogList = [[NSMutableArray alloc] init];
    
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        [blogList addObjectsFromArray:[dict objectForKey:@"statuses"]];
        NSLog(@"%d",blogList.count);
        [blogTableView reloadData];
    } else {
        [ModalAlert say:@"连接超时\n请稍检查您的网络设置..."];
    }
    
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"requestDidFailWithError: %@", error);
}

@end
