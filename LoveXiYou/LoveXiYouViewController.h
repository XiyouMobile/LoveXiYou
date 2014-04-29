//
//  LoveXiYouViewController.h
//  LoveXiYou
//
//  Created by  on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ivan_UITabBar.h"
#import "UIBadgeView.h"

@interface LoveXiYouViewController : Ivan_UITabBar{
    UINavigationController  *newsNav;       //首页
    UINavigationController  *groupNav;      //校园
    UINavigationController  *courseNav;     //课程表
    UINavigationController  *moreNav;       //更多
}

@end
