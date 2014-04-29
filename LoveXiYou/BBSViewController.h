//
//  BBSViewController.h
//  LoveXiYou
//
//  Created by  on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TFHpple.h"
#import "SVProgressHUD.h"
#import "Spinner.h"

@interface BBSViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,sendTitleDelegate>{
    Spinner        *spinner;         //要显示的列表视图
    NSMutableArray *bbsArray;        //bbs分类数组
    
    UITableView    *bbsNewsTable;    //标题表格，共15条
    NSMutableArray *bbsNewsArr;      //动态加载标题的表格
    NSArray        *bbsNewsArray;    //标题数组，存储解析后所得标题内容
    NSMutableArray *bbsHrefArr;      //标题所对应动态的链接数组，动态加载数据到数组
    NSArray        *bbsHrefArray;    //链接数组，存储解析后所得链接内容
    
    int viewTag;                         //本周热门，跳蚤交易，最新帖子的数值标志
}

//将gbk编码转换为UTF-8编码
- (NSData *) toUtf8:(NSData *)inData;
//显示响应界面
- (void)showList;
//初始显示本周热门，点击列表显示对应界面的内容
- (void)showListContent:(int)_tag;

@end
