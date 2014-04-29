//
//  LoveXiYouAppDelegate.h
//  LoveXiYou
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsViewController.h"
#import "GroupViewController.h"
#import "MoreViewController.h"
#import "CourseViewController.h"
#import "MobClick.h"
#import "LoveXiYouViewController.h"

#define UMENG_APPKEY @"4fc61e6652701510ae00001a"   

@interface LoveXiYouAppDelegate : UIResponder <UIApplicationDelegate> {
    LoveXiYouViewController *myTabBarVC;
    UITabBarController      *tabBarController;
    UINavigationController  *newsNav;
    UINavigationController  *groupNav;
    UINavigationController  *courseNav;
    UINavigationController  *moreNav;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) LoveXiYouViewController *myTabBarVC;

@end
