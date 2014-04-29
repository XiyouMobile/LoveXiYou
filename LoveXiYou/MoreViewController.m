//
//  MoreViewController.m
//  LoveXiYou
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "ModalAlert.h"
#import "MobileLabViewController.h"
#import "UserManageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ModalAlert.h"

@implementation MoreViewController
@synthesize  scrollView;
@synthesize  sizeSlider;
@synthesize  aboutUsBg,updateBg,userResponseBg,userManageBg,moreViewBg;

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
    [scrollView release];
    [sizeSlider release];
    [userManageBg release];
    [aboutUsBg release];
    [userResponseBg release];
    [updateBg release];
    [moreViewBg release];
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
    [MobClick event:@"更多"];
    userResponseBg.image = [UIImage imageNamed:@"邮电绿色更多按钮背景"];
    aboutUsBg.image = [UIImage imageNamed:@"邮电绿色更多按钮背景"];
    updateBg.image = [UIImage imageNamed:@"邮电绿色更多按钮背景"];
    moreViewBg.image = [UIImage imageNamed:@"邮电绿色更多按钮背景"];
    userManageBg.image = [UIImage imageNamed:@"邮电绿色更多按钮背景"];
    
    //3G实验室介绍
    userResponseBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateClientBg)];
    [userResponseBg addGestureRecognizer:singleTap];
    [singleTap release];
    
    //联系我们，邮箱
    updateBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userResponseButtonClick)];
    [updateBg addGestureRecognizer:singleTap1];
    [singleTap1 release];
    
    //用户反馈，友盟
    aboutUsBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutUsButtonClick)];
    [aboutUsBg addGestureRecognizer:singleTap3];
    [singleTap3 release];
    
    //更多精彩
    moreViewBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreViewButtonClick)];
    [moreViewBg addGestureRecognizer:singleTap4];
    [singleTap4 release];
    
    //账号管理
    userManageBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userManageViewButtonClick)];
    [userManageBg addGestureRecognizer:singleTap5];
    [singleTap5 release];
    
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height+100);
    
}

//用户反馈，邮箱
- (void)userResponseButtonClick{
    if (![CloNetworkUtil getNetWorkStatus]) {
        [ModalAlert say:@"未连接网络\n请稍检查您的网络设置..."];
    }else {
        [self sendEMail];
    }
}

-(void)launchMailAppOnDevice {
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(void)displayComposerSheet {
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    [mailPicker setSubject:@"eMail主题"];
    
    NSArray *toRecipients = [NSArray arrayWithObjects:@"xiyoumobileclub@163.com",nil];
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"xiyoumobileclub@163.com",nil];
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"xiyoumobileclub@163.com", nil];
    [mailPicker setToRecipients:toRecipients];
    [mailPicker setCcRecipients:ccRecipients];    
    [mailPicker setBccRecipients:bccRecipients];
    
    NSString *emailBody = @"请输入您要咨询的信息...";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController:mailPicker animated:YES];
    [mailPicker release];
}

-(void)sendEMail {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil) {
        if ([mailClass canSendMail]) {
            [self displayComposerSheet];
        } else {
            [self launchMailAppOnDevice];
        }
    } else {
        [self launchMailAppOnDevice];
    }    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSString *msg;
    
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            //[self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            // [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            // [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    NSLog(@"发送结果：%@", msg);
    [self dismissModalViewControllerAnimated:YES];
}

//3G实验室介绍
-(void)updateClientBg{
    MobileLabViewController *mobleController = [[MobileLabViewController alloc] init];
    [self.navigationController pushViewController:mobleController animated:YES];
    [mobleController release];
}

//用户反馈，友盟
- (void)aboutUsButtonClick{
    if (![CloNetworkUtil getNetWorkStatus]) {
        [ModalAlert say:@"未连接网络\n请稍检查您的网络设置..."];
    }else {
        [MobClick showFeedback:self];
    }
}

//更多精彩
- (void)moreViewButtonClick{
    [ModalAlert say:@"正在开发中\n请耐心等待..."];
}

//账号管理
- (void)userManageViewButtonClick{
    [ModalAlert say:@"正在开发中\n请耐心等待..."];
    /*if (![CloNetworkUtil getNetWorkStatus]) {
        [ModalAlert say:@"未连接网络\n请稍检查您的网络设置..."];
    }else {
        UserManageViewController *userManageController = [[UserManageViewController alloc] init];
        [self.navigationController pushViewController:userManageController animated:YES];
        [userManageController release];
    }*/
    
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
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

@end
