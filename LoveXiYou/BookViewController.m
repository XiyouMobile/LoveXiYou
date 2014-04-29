//
//  BookViewController.m
//  LoveXiYou
//
//  Created by  on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookViewController.h"
#import "UIViewController+AddTitleView.h"
#import "ModalAlert.h"

#define urlPath @"http://222.24.63.101/library/login"

@implementation BookViewController
@synthesize userID = _userID;
@synthesize userKey = _userKey;
@synthesize cookies = _cookies;
@synthesize okButton;
@synthesize data = _data;
@synthesize bookInfo = _bookInfo;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    self.navigationItem.title = @"西邮图书馆";
    [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航返回按钮" Event:@selector(backTo:)];
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"邮电绿色图书馆"]];
    backImageView.frame = CGRectMake(0, 0, 320, 367);
    [self.view addSubview:backImageView];
    [backImageView release];
    backImageView = nil;
    _userID = [[UITextField alloc] initWithFrame:CGRectMake(115,113,158,28)];
    _userID.placeholder = @"口令";
    _userID.borderStyle = UITextBorderStyleRoundedRect;
    _userID.textAlignment = UITextAlignmentCenter;
    _userID.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNumber"];
    _userID.returnKeyType = UIReturnKeyNext;
    [_userID addTarget:self action:@selector(textDone) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_userID];
    
    
    _userKey = [[UITextField alloc] initWithFrame:CGRectMake(115,156,158,27)];
    _userKey.placeholder = @"密码";
    _userKey.secureTextEntry = YES;
    _userKey.borderStyle = UITextBorderStyleRoundedRect;
    _userKey.textAlignment = UITextAlignmentCenter;
    _userKey.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    _userKey.keyboardType = UIKeyboardTypeNumberPad;

    [self.view addSubview:_userKey];
    
    okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [okButton setFrame:CGRectMake(120, 237, 80, 35)];
        [okButton setImage:[UIImage imageNamed:@"邮电绿色图书馆登录按钮"] forState:UIControlStateNormal];
    [okButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [okButton addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
    
}

- (void)backTo:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 
#pragma mark textfiled Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
	[self.view setFrame:CGRectMake(0, -190, 320, 460)];
}

-(IBAction)textDone{
    
    [_userKey becomeFirstResponder];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userID resignFirstResponder];
    [_userKey resignFirstResponder];
}

#pragma mark - 
#pragma mark Request Delegate
//作用：判断登陆是否成功
-(NSString *)bookListRequest{
    NSURL *url0 = [NSURL URLWithString:urlPath];
    ASIFormDataRequest *request0 = [[ASIFormDataRequest alloc] initWithURL:url0];
    
    [request0 setPostValue:_userID.text forKey:@"userNumber"];
    [request0 setPostValue:_userKey.text forKey:@"password"];
    [request0 startSynchronous];
    
    return [request0 responseString];
}
 
-(void)ok
{
    [MobClick event:@"ok" label:@"ok" acc:1];
    
    [_userKey resignFirstResponder];
    [_userID resignFirstResponder];
    [self.view setFrame:CGRectMake(0,20, 320, 460)];
    
    NSString *result =[self bookListRequest];
    if ([result isEqualToString:@"shibai"] || [result isEqualToString:@"null"]) {

        
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"用户口令或密码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [myAlert show];
        [myAlert release];
    }else {
        NSLog(@"登陆成功！");
        
        showBook *myControllerView = [[showBook alloc] init];
        myControllerView.bookListString = result;
        myControllerView.delegate = self;
        myControllerView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

        [self.navigationController pushViewController:myControllerView animated:YES];
        [myControllerView release];
        
        [[NSUserDefaults standardUserDefaults] setObject:_userID.text forKey:@"userNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:_userKey.text forKey:@"password"];
    }
}

-(void)dealloc{
    
    [_userID release];
    [_userKey release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end
