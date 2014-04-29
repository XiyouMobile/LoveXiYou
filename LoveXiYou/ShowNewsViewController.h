//
//  ShowNewsViewController.h
//  LoveXiYou
//
//  Created by  on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "SVProgressHUD.h"

@interface ShowNewsViewController : UIViewController <UITextViewDelegate>{
    NSString        *_titleString;
    NSString        *_hrefString;
    NSMutableString *contentString;
    
    int viewTag;
    int arrayFlag;
}

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *hrefString;

//初始化controller,设置viewTag
- (id)initWithTag:(int)_viewTag;
//解析公告或新闻的内容
- (NSString *)XPathParsing;
//将gbk转码为utf8
- (NSData *) toUtf8:(NSData *)inData;
//递归实现，解析公告或新闻内容
- (void)contentArray:(NSArray *)_array contentCount:(int)_count;

@end
