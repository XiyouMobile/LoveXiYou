//
//  userResponseController.m
//  LoveXiYou
//
//  Created by mobilephone xiyou on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "userResponseController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+AddTitleView.h"

@implementation userResponseController
@synthesize suggestionText;
@synthesize emailField;
@synthesize responseWord;

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
    [suggestionText release];
    [emailField release];
    [responseWord release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setrightBarButtonItem:@"发送" orImaged:nil Event:@selector(sendTo:)];
    [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航返回按钮" Event:@selector(backTo:)];
    
    responseWord.font = [UIFont fontWithName:@"宋体" size:15];
    suggestionText.delegate = self;
    suggestionText.layer.borderWidth = 2.0f;
    suggestionText.layer.borderColor = [[UIColor grayColor] CGColor];
    suggestionText.layer.cornerRadius = 6.0f;//设置textView的圆角半径
    suggestionText.layer.masksToBounds = YES;
    //根据版本显示的用户反馈文本框的大小，因为5.0版本键盘中文输入的框比较长
    if([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] < 5)
    {
        suggestionText.frame = CGRectMake(10, suggestionText.frame.origin.y, 300, 100);
        emailField.frame = CGRectMake(10, suggestionText.frame.origin.y+105, 300, 32);
    }
    else
    {
        suggestionText.frame = CGRectMake(10, suggestionText.frame.origin.y, 300, 68);
        emailField.frame = CGRectMake(10, suggestionText.frame.origin.y+73, 300, 32);
    }
    
    emailField.layer.borderWidth = 2.0f;
    emailField.layer.borderColor = [[UIColor grayColor] CGColor];
    emailField.layer.cornerRadius = 6.0f;
    emailField.layer.masksToBounds = YES;
    suggestionText.text = @"请输入您的意见...";
    [suggestionText becomeFirstResponder];

}

- (void)backTo:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendTo:(id)sender{
    NSString *strMessage = suggestionText.text;
    if (strMessage == nil || [strMessage isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"信息提示" message:@"请填写发送的信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
        [av release];
        return;
    }
    MFMailComposeViewController *picker =[[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:responseWord.text];
    [picker setMessageBody:suggestionText.text isHTML:NO];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissModalViewControllerAnimated:YES];
}

- (IBAction)emailEditBegin{
    if ([emailField.text isEqualToString:@"主题(Subject)"]) {
        emailField.text = @"";
    }
}

- (IBAction)emailEditEnd{
    if ([emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        emailField.text = @"主题(Subject)";
    }
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
