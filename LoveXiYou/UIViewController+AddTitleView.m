//
//  UIViewController+AddTitleView.m
//  VLive2
//
//  Created by allenapple on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+AddTitleView.h"

@implementation UIViewController (AddTitleView)
/*****
 设置VIewControllerTitle
 *****/
-(void)setNavBarTitle:(NSString *)_titled orImaged:(NSString *)imageName{
    
    if (_titled) {
        CGRect frame = CGRectMake(0, 0, 200, 44); 
        UILabel *label = [[UILabel alloc] initWithFrame:frame]; 
        label.backgroundColor = [UIColor clearColor]; 
        label.font = [UIFont boldSystemFontOfSize:20.0]; 
        //    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5]; 
        label.textAlignment = UITextAlignmentCenter; 
        label.textColor = [UIColor colorWithRed:0.663 green:0 blue:0.267 alpha:1.0]; 
        label.text=_titled;
        self.navigationItem.titleView = label;
        [label release];
    }
    if(imageName){
        
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(105, 2, 110, 40)];
        imageview.image=[UIImage imageNamed:imageName];
        self.navigationItem.titleView=imageview;
        [imageview release];
    }
}
/*****
 设置左按钮
 *****/
-(void)setleftBarButtonItem:(NSString *)_titled orImaged:(NSString *)imageName Event:(SEL)_event{
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 100 / 3, 22)];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    if (_titled) {
        [btn setTitle:_titled forState:UIControlStateNormal];
    }
    if (imageName) {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    [btn addTarget:self action:_event forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn release];
    self.navigationItem.leftBarButtonItem=item;
    [item release];
    
    /*UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:_titled style:UIBarButtonItemStyleBordered target:self action:_event];
     //[btn release];
     self.navigationItem.leftBarButtonItem = item;
     [item release];*/
    
}
/*****
 设置右按钮
 *****/
-(void)setrightBarButtonItem:(NSString *)_titled orImaged:(NSString *)imageName Event:(SEL)_event{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 100 / 3, 22)];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    if (_titled) {
        [btn setTitle:_titled forState:UIControlStateNormal];
    }
    if (imageName) {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    [btn addTarget:self action:_event forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn release];
    self.navigationItem.rightBarButtonItem=item;
    [item release];
    
    /*UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:_titled style:UIBarButtonItemStyleBordered target:self action:_event];
     //[btn release];
     self.navigationItem.rightBarButtonItem=item;
     [item release];*/
    
}

@end
