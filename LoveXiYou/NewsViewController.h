//
//  NewsViewController.h
//  LoveXiYou
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogoViewCell.h"
#import "ImageAndTitle.h"
#import "LogoCrossViewCell.h"
#import "ModalAlert.h"
#import "MobClick.h"

@interface NewsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,cellItemDelegate,cellItemCrossDelegate>{
    UITableView       *logoTableView_;
    LogoViewCell      *logoViewCell_;           //竖屏cell
    LogoCrossViewCell *logoCrossViewCell_;      //横屏cell
    NSMutableArray    *itemArray;               //表格中按钮和标签的图片与文字
    NSArray           *titleArray;
    NSArray           *imageArray;
    int arrLeave;
    
}

//设定itemArray
- (void)setItem:(NSArray *)temperatureArray;
//为itemArray中添加对象
- (void)addItem:(ImageAndTitle *)iat;
//设定tableView中cell中的内容,竖屏时
- (UITableViewCell *)setCellItem:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//设定tableView中cell中的内容,横屏时
- (UITableViewCell *)setCellItem:(UITableView *)tableView cellForRowAtIndexPathCross:(NSIndexPath *)indexPath;

@end
