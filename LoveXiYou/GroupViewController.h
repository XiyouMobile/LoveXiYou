//
//  GroupViewController.h
//  LoveXiYou
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlogsInformationViewController.h"
#import "WBLogInAlertView.h"
#import "WBEngine.h"
#import "Spinner.h"
#import "DetailBlogViewController.h"
#import "MobClick.h"
#import "CloNetworkUtil.h"

@interface GroupViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate,WBEngineDelegate,WBRequestDelegate,WBLogInAlertViewDelegate,sendTitleDelegate>{
    Spinner                 *spinner;
    NSMutableArray          *blogArray;
    UITableView             *blogTableView;
    
    WBEngine                *blogEngie;
    NSMutableArray          *userList;
    NSMutableArray          *blogList;
    
    NSString                *appKey;
    NSString                *appSecret;
    BOOL isHidden;
    
}
@property(nonatomic, retain)UITableView             *blogTableView;
@property(nonatomic, retain)WBEngine                *blogEngie;

- (void)talkTo:(id)sender;
- (void)loginOn;
- (void)loginOut:(id)sender;
- (void)getBlogMessage;
- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;
- (void)initShowList;

@end
