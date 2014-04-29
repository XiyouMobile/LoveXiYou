//
//  BlogSendViewController.h
//  LoveXiYou
//
//  Created by mobilephone xiyou on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "WBEngine.h"

@class BlogSendViewController;

@protocol BlogSendViewDelegate <NSObject>

@optional

- (void)sendViewWillAppear:(BlogSendViewController *)view;
- (void)sendViewDidAppear:(BlogSendViewController *)view;
- (void)sendViewWillDisappear:(BlogSendViewController *)view;
- (void)sendViewDidDisappear:(BlogSendViewController *)view;

- (void)sendViewDidFinishSending:(BlogSendViewController *)view;
- (void)sendView:(BlogSendViewController *)view didFailWithError:(NSError *)error;

- (void)sendViewNotAuthorized:(BlogSendViewController *)view;
- (void)sendViewAuthorizeExpired:(BlogSendViewController *)view;

@end


@interface BlogSendViewController : UIView <UITextViewDelegate, WBEngineDelegate> 
{
    UITextView  *contentTextView;
    UIButton    *sendButton;
    UIButton    *closeButton;
    UIButton    *clearTextButton;
    
    UILabel     *titleLabel;
    UILabel     *wordCountLabel;
    
    UIView      *panelView;
    UIImageView *panelImageView;
    
    NSString    *contentText;
    UIImage     *contentImage;
    
    UIInterfaceOrientation previousOrientation;
    
    BOOL        isKeyboardShowing;
    
    WBEngine    *engine;
    NSString    *weibo_ID;
    
    id<BlogSendViewDelegate> delegate;
    NSString *blogContext;
    NSInteger tag;
    
    NSString *sendName;
}

@property (nonatomic, retain) NSString *contentText;
@property (nonatomic, retain) UIImage *contentImage;
@property (nonatomic, retain) NSString *weibo_ID;
@property (nonatomic, assign) id<BlogSendViewDelegate> delegate;
@property (nonatomic, retain) NSString *blogContext;
@property (nonatomic) NSInteger tag;

@property (nonatomic, retain) NSString *sendName;

- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret text:(NSString *)text;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
