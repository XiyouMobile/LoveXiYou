//
//  DetailBlogViewController.h
//  LoveXiYou
//
//  Created by mobilephone xiyou on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "SinaBlogApp.h"
#import "BlogsInformationViewController.h"
#import "BlogSendViewController.h"

@interface DetailBlogViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, WBEngineDelegate,WBRequestDelegate,BlogSendViewDelegate>
{
    NSString       *appKey;
    NSString       *appSecret;
    
    WBEngine       *blogEngine;
    
    UITableView    *weiBoTableView;   //用于显示当前用户的所有微博
    
    NSMutableArray *weiBoList;     //存储当前用户的所有微博内容
    
}
- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;
- (void)loginOn;

@end

