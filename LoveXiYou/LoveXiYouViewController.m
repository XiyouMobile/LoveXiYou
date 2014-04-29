//
//  LoveXiYouViewController.m
//  LoveXiYou
//
//  Created by  on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoveXiYouViewController.h"
#import "NewsViewController.h"
#import "GroupViewController.h"
#import "MoreViewController.h"
#import "CourseViewController.h"
#import "UIViewController+AddTitleView.h"

// ============================= iOS4 start =========================

@implementation LoveXiYouViewController

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
    [newsNav release];
    newsNav = nil;
    [groupNav release];
    groupNav = nil;
    [courseNav release];
    courseNav = nil;
    [moreNav release];
    moreNav = nil;
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
    
    NewsViewController *newsViewController = [[NewsViewController alloc] init];
    newsViewController.title = @"首页";
    UITabBarItem *newsTabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"邮电绿色标签栏_首页"] tag:110];
    newsViewController.tabBarItem = newsTabBarItem;
    [newsTabBarItem release];
    newsNav = [[UINavigationController alloc] initWithRootViewController:newsViewController];
    [newsViewController release];
    
    GroupViewController *groupViewController = [[GroupViewController alloc] init];
    groupViewController.title = @"校园";
    UITabBarItem *groupTabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"邮电绿色标签栏_校园"] tag:111];
    groupViewController.tabBarItem = groupTabBarItem;
    [groupTabBarItem release];
    groupNav = [[UINavigationController alloc] initWithRootViewController:groupViewController];
    [groupViewController release];
    
    CourseViewController *courseViewController = [[CourseViewController alloc] init];
    courseViewController.title = @"课程表";
    UITabBarItem *courseTabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"邮电绿色标签栏_课程表"] tag:112];
    courseViewController.tabBarItem = courseTabBarItem;
    [courseTabBarItem release];
    courseNav = [[UINavigationController alloc] initWithRootViewController:courseViewController];
    [courseViewController release];
    
    MoreViewController *moreViewController = [[MoreViewController alloc] init];
    moreViewController.title = @"更多";
    UITabBarItem *moreTabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"邮电绿色标签栏_更多"] tag:113];
    moreViewController.tabBarItem = moreTabBarItem;
    [moreTabBarItem release];
    moreNav = [[UINavigationController alloc] initWithRootViewController:moreViewController];
    [moreViewController release];
    
    NSArray *controllers = [NSArray arrayWithObjects:newsNav,groupNav,courseNav,moreNav, nil];
    self.viewControllers = controllers;
    self.selectedIndex = 0;
    [controllers release];
    
    UIDevice *dev = [UIDevice currentDevice];
    NSString *systemVersion=dev.systemVersion;
    int  Version_I= [[systemVersion substringWithRange:NSMakeRange(0, 1)] intValue];
    UIImage* smallImage= [UIImage imageNamed:@"邮电绿色_导航栏"];

    //适用于ios5
    if (Version_I>4) {
        [newsNav.navigationBar setBackgroundImage:smallImage forBarMetrics:UIBarMetricsDefault];
        [groupNav.navigationBar setBackgroundImage:smallImage forBarMetrics:UIBarMetricsDefault];
        [courseNav.navigationBar setBackgroundImage:smallImage forBarMetrics:UIBarMetricsDefault];
        [moreNav.navigationBar setBackgroundImage:smallImage forBarMetrics:UIBarMetricsDefault];
        
    }else{
        newsNav.navigationBar.layer.contents = (id)smallImage.CGImage;
        groupNav.navigationBar.layer.contents=(id)smallImage.CGImage;
        courseNav.navigationBar.layer.contents = (id)smallImage.CGImage;
        moreNav.navigationBar.layer.contents = (id)(id)smallImage.CGImage;
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
