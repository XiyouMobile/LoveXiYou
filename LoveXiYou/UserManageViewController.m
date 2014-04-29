//
//  UserManageViewController.m
//  LoveXiYou
//
//  Created by Pro on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserManageViewController.h"
#import "UIViewController+AddTitleView.h"
#import "SinaBlogApp.h"
#import "ModalAlert.h"

@interface UserManageViewController ()

@end

@implementation UserManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [super dealloc];
    //[blogEngie release];
    [userTableView release];
    userTableView = nil;
    //[userArray release];
    //userArray = nil;
    //[keys release];
    //keys = nil;
    //[dict release];
    //dict = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [self showUserList];
}

- (void)viewDidDisappear:(BOOL)animated{
    [userArray release];
    userArray = nil;
    [blogEngie release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"账号管理";
    [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航返回按钮" Event:@selector(backTo:)];
    [self setrightBarButtonItem:nil orImaged:@"邮电绿色导航添加按钮" Event:@selector(addTo:)];
    
    userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
    userTableView.delegate = self;
    userTableView.dataSource = self;
    userTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userTableView];
    
    //[self showUserList];
    
}

- (void)backTo:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTo:(id)sender{
    if (![CloNetworkUtil getNetWorkStatus]) {
        [ModalAlert say:@"未连接网络\n请稍检查您的网络设置..."];
    }else {
        [blogEngie logIn];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showUserList{
    
    blogEngie = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [blogEngie setRootViewController:self];
    [blogEngie setDelegate:self];
    [blogEngie setRedirectURI:@"http://"];
    [blogEngie setIsUserExclusive:NO];
    
    if ([blogEngie isLoggedIn] && ![blogEngie isAuthorizeExpired]) {
        //已登录，获得用户名添加
        NSLog(@"userID=%@,accessToken=%@,expireTime=%f",blogEngie.userID,blogEngie.accessToken,blogEngie.expireTime);
        
        NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:blogEngie.userID,@"uid", nil];
        
        [blogEngie loadRequestWithMethodName:@"users/show.json" 
                                  httpMethod:@"GET" 
                                      params:myDict 
                                postDataType:kWBRequestPostDataTypeNormal 
                            httpHeaderFields:nil];
        
    }else{
        //[self setleftBarButtonItem:@"登陆" orImaged:nil Event:@selector(loginOn:)]; 
        //未登录 
    }
    
}

- (void)addUser:(NSDictionary *)userDic{
    
    userArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    int i;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UserList" ofType:@"plist"];
    dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"dict:%@",dict);
    
    keys = [[NSArray alloc] initWithArray:[dict objectForKey:@"UserList"]];
    NSLog(@"keys:%@",keys);
    
    for (i = 0; i < [keys count]; i++) {
        if ([[NSString stringWithFormat:@"%@",[[keys objectAtIndex:i] objectForKey:@"userName"]] isEqualToString:[NSString stringWithFormat:@"%@",[userDic objectForKey:@"screen_name"]]]) {
            break;
        }
    }
    
    if (i == [keys count]) {
        for (int j = 0; j < [keys count]; j++) {
            [userArray addObject:[keys objectAtIndex:j]];
        }
        NSLog(@"userArray:%@",userArray);
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        [userDict setObject:blogEngie.userID forKey:@"userID"];
        [userDict setObject:blogEngie.accessToken forKey:@"accessToken"];
        [userDict setObject:[NSNumber numberWithDouble:blogEngie.expireTime] forKey:@"expireTime"];
        [userDict setObject:[userDic objectForKey:@"screen_name"] forKey:@"userName"];
        [userArray addObject:userDict];
        [userDict release];
        [self writeUserList:NO];
        NSLog(@"%d",userArray.count);
        NSLog(@"%@",userArray);
        [userTableView reloadData];
    }
    
    [dict release];
    [keys release];
}

- (void)writeUserList:(BOOL)isNull{
    if (isNull) {
        dict = nil;
    }else {
        [dict setObject:userArray forKey:@"UserList"];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UserList" ofType:@"plist"];
    [dict writeToFile:path atomically:YES];
    
}

#pragma mark -
#pragma mark UITableViewDataSource

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellIdentifier] autorelease];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.tag = indexPath.row;
    [deleteBtn setImage:[UIImage imageNamed:@"邮电绿色删除"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteTo:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setFrame:CGRectMake(240, 7, 70, 30)];
    [cell addSubview:deleteBtn];
    
    cell.textLabel.text = [[userArray objectAtIndex:indexPath.row] objectForKey:@"userName"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"row:%i",indexPath.row);
    
    if (![blogEngie.userID isEqualToString:[[userArray objectAtIndex:indexPath.row] objectForKey:@"userID"]]) {
        blogEngie.userID = nil;
        blogEngie.accessToken = nil;
        blogEngie.expireTime = 0;
        blogEngie.userID = [[userArray objectAtIndex:indexPath.row] objectForKey:@"userID"];
        blogEngie.accessToken = [[userArray objectAtIndex:indexPath.row] objectForKey:@"accessToken"];
        blogEngie.expireTime = [[[userArray objectAtIndex:indexPath.row] objectForKey:@"expireTime"] doubleValue];
    }else {
        [ModalAlert say:@"您已经登陆！"];
    }
    
}

- (void)deleteTo:(id)sender{
    UIButton *button = (UIButton *)sender;
    if ([[[userArray objectAtIndex:button.tag] objectForKey:@"userID"] isEqualToString:blogEngie.userID]) {
        [blogEngie logOut];
    }
    [userArray removeObjectAtIndex:button.tag];
    if ([userArray count] > 0) {
        [self writeUserList:NO];
    }else {
        [self writeUserList:YES];
    }
    [userTableView reloadData];
}

- (void)refreshUser{
    NSDictionary *myDict = [[NSDictionary alloc] initWithObjectsAndKeys:blogEngie.userID,@"uid", nil];
    
    [blogEngie loadRequestWithMethodName:@"users/show.json" 
                              httpMethod:@"GET" 
                                  params:myDict 
                            postDataType:kWBRequestPostDataTypeNormal 
                        httpHeaderFields:nil];
}

#pragma mark - WBEngineDelegate Methods
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result{
    
    //[SVProgressHUD dismiss];
    
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *userDict = (NSDictionary *)result;
        [self addUser:userDict];
    }
    
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    //[SVProgressHUD dismiss];
    NSLog(@"requestDidFailWithError: %@", error);
}

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
    [self refreshUser];
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

@end
