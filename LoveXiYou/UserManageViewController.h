//
//  UserManageViewController.h
//  LoveXiYou
//
//  Created by Pro on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "CloNetworkUtil.h"

@interface UserManageViewController : UIViewController <WBEngineDelegate,WBRequestDelegate,UITableViewDelegate,UITableViewDataSource>{
    WBEngine            *blogEngie;
    UITableView         *userTableView;
    NSMutableArray      *userArray;
    
    NSMutableDictionary *dict;
    NSArray             *keys;
}

//显示添加用户的名称列表
- (void)showUserList;
//将新的用户写入到UserList.plist文件
- (void)writeUserList:(BOOL)isNull;
//将新的用户写入到userArray表格中
- (void)addUser:(NSDictionary *)userDic;

@end
