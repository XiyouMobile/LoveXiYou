//
//  MobileLabViewController.m
//  LoveXiYou
//
//  Created by  on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MobileLabViewController.h"
#import "UIViewController+AddTitleView.h"

@implementation MobileLabViewController

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
    self.title = @"3G实验室";
    [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航返回按钮" Event:@selector(backTo:)];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resPath = [bundle resourcePath];
    
    NSString *filePath = nil;
    
    filePath = [resPath stringByAppendingPathComponent:[NSString stringWithFormat:@"实验室.html"]];
    
    [webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]
                    baseURL:[NSURL fileURLWithPath:[bundle bundlePath]]];
    [self.view addSubview:webView];
    [webView release];
    webView = nil;
}

- (void)backTo:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
