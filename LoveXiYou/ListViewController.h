//
//  ListViewController.h
//  LoveXiYou
//
//  Created by  on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spinner.h"
#import "SVProgressHUD.h"

@interface ListViewController : UIViewController <sendTitleDelegate,UITableViewDelegate,UITableViewDataSource> {
    Spinner        *spinner;         //要显示的列表视图
    NSMutableArray *partArray;       //院系数组
    NSMutableArray *introductionArr; //西邮简介数组
    
    int viewTag;                     //视图tag
    
    UITableView    *mailListTable;   //通讯录表格
    NSArray        *mailArr;         //从Mail.plist获取的数组，包括长度为0的
    NSMutableArray *mailArray;       //从Mail.plist获取的数组，包括长度为0的
    NSMutableArray *mailResultArr;   //从Mail.plist获取的数组，不包括长度为0的
    NSArray        *mailResultArray; //从Mail.plist获取的数组，不包括长度为0的
    NSArray        *keys;            //Mail.plist中从A到Z
    NSDictionary   *dict;            //从Mail.plist首次获取数据，存入dict中
    
    BOOL isHidden;
}

//初始化ListViewController，设定视图的tag
- (id)initWithViewTag:(int)_viewTag;
//从tag值判断是西邮简介还是院系列表，显示响应界面
- (void)showList:(int)_viewTag;

@end
