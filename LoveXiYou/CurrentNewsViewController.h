//
//  CurrentNewsViewController.h
//  LoveXiYou
//
//  Created by  on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TFHpple.h"
#import "SVProgressHUD.h"
#import "Spinner.h"
#import "CloNetworkUtil.h"

@interface CurrentNewsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,sendTitleDelegate>{
    Spinner        *spinner;            //要显示的列表视图
    NSMutableArray *currentArray;       //实事分类数组
    
    UITableView    *currentNewsTable;    //标题表格，共15条
    NSMutableArray *currentNewsArr;      //动态加载标题的表格
    NSArray        *currentNewsArray;    //标题数组，存储解析后所得标题内容
    NSMutableArray *currentHrefArr;      //标题所对应动态的链接数组，动态加载数据到数组
    NSArray        *currentHrefArray;    //链接数组，存储解析后所得链接内容
    
    int viewTag;                         //西邮公告，学术公告，西邮新闻的数值标志
    
    BOOL isHidden;
    
    NSData   *htmlGetData;
}

//将gbk编码转换为UTF-8编码
- (NSData *) toUtf8:(NSData *)inData;
//显示响应界面
- (void)showList;
//初始显示西邮公告，点击列表显示对应界面的内容
- (void)showListContent:(int)_tag;

@end
