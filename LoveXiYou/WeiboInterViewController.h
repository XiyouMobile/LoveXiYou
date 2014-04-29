//
//  WeiboInterViewController.h
//  LoveXiYou
//
//  Created by mobilephone xiyou on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"

@interface WeiboInterViewController : UIViewController<WBEngineDelegate,WBRequestDelegate,UIAlertViewDelegate>{
    WBEngine                *blogEngine;
    UIActivityIndicatorView *indicatorView;
    
    NSString                *appKey;
    NSString                *appSecret;
    NSMutableArray          *blogList;//存储所有微博内容
    NSMutableArray          *commentList;
    NSMutableArray          *userList;//存储所添加的用户
    
    NSString                *alertMessage;
}
@property(nonatomic, retain)WBEngine                *blogEngine;
@property(nonatomic, retain)UIActivityIndicatorView *indicatorView;

//登陆
- (void)loginOn:(id)sender;
//- (void)refreshViewData;
- (void)refreshTimeline;
//获取微博评论列表
- (void)commentList:(NSString *)weiboID;
//取消关注
- (void)cancelFollow:(NSString *)screenName;
//关注
- (void)followButton:(NSString *)screenName;
//转发
- (void)forwardButton:(NSString *)weiboID addContext:(NSString *)context;
//评论
- (void)commentButton:(NSString *)weiboID addContext:(NSString *)context;
//收藏
- (void)collectButton:(NSString *)weiboID;
- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;
@end
