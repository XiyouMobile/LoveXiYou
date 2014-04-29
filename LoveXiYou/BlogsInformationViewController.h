//
//  BlogsInformationViewController.h
//  LoveXiYou
//
//  Created by mobilephone xiyou on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "BlogSendViewController.h"

@interface BlogsInformationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,WBEngineDelegate,WBRequestDelegate,UIAlertViewDelegate,BlogSendViewDelegate>{
    UITableView *commentTableView;
    
    IBOutlet UIImageView    *iconImageView;
    IBOutlet UILabel        *nameLabel;
    IBOutlet UITextView     *introTextView;
    IBOutlet UIButton       *followButton;
    IBOutlet UIButton       *SubmissionButton; 
    
    IBOutlet UIImageView    *blogBackView;
    IBOutlet UITextView     *blogTextView;
    IBOutlet UIButton       *commentBut;
    IBOutlet UIButton       *forwardBut;
    IBOutlet UIButton       *collectionBut;
             NSString       *blogContext;//微博内容
    
    NSString                *forwardContext;//转发的内容
    NSString                *weibo_ID;
    NSString                *webo_Name;
    NSString                *appKey;
    NSString                *appSecret;
    NSDictionary            *userDict;
    WBEngine                *engine; 
    NSString                *alertMessage;  //警告信息
    NSMutableArray          *commentList; //评论内容
    
    NSInteger uFlag;
    NSInteger cFlag;
    
    NSInteger buttonTag;
}
@property(nonatomic, retain) UITableView          *commentTableView;
@property(nonatomic, retain) IBOutlet UIImageView *iconImageView;
@property(nonatomic, retain) IBOutlet UILabel     *nameLabel;
@property(nonatomic, retain) IBOutlet UITextView  *introTextView;
@property(nonatomic, retain) IBOutlet UIButton    *followButton;
@property(nonatomic, retain) IBOutlet UIButton    *SubmissionButton;

@property(nonatomic, retain)IBOutlet UITextView   *blogTextView;
@property(nonatomic, retain)IBOutlet UIButton     *commentBut;
@property(nonatomic, retain)IBOutlet UIButton     *forwardBut;
@property(nonatomic, retain)IBOutlet UIButton     *collectionBut;
@property(nonatomic, retain)NSString              *blogContext;
@property(nonatomic, retain)NSString              *weibo_ID;
@property(nonatomic, retain)NSString              *weibo_Name;

- (void)backTo:(id)sender;
//- (void)loginOn:(id)sender;
- (void)userMessage;
//获取评论列表
- (void)getCommentList;
- (IBAction)commentButPressed:(id)sender;
- (IBAction)forwardButPressed:(id)sender;
- (void)isCollected:(NSString *)_ID;
- (void)destoryCollected:(NSString *)_ID;
- (IBAction)collectButPressed:(id)sender;
- (IBAction)isFollowed:(id)sender;
- (void)destoryFollowed:(NSString *)_name;
- (void)addFollowed:(NSString *)_name;
- (IBAction)SubmissionButPressed:(id)sender;
- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;
- (void)loginOn;

@end
