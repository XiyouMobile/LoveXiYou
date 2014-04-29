//
//  UIViewController+AddTitleView.h
//  VLive2
//
//  Created by allenapple on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AddTitleView)
/*****
 设置VIewControllerTitle
 *****/
-(void)setNavBarTitle:(NSString *)_titled orImaged:(NSString *)imageName;
/*****
 设置左按钮
 *****/
-(void)setleftBarButtonItem:(NSString *)_titled orImaged:(NSString *)imageName Event:(SEL)_event;
/*****
 设置右按钮
 *****/
-(void)setrightBarButtonItem:(NSString *)_titled orImaged:(NSString *)imageName Event:(SEL)_event;
@end
