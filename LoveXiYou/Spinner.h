//
//  Spinner.h
//  Spinner
//
//  Created by 软件业务 on 11-4-1.
//  Copyright 2011 huitu.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendTitleDelegate <NSObject>

- (void)sendTitle:(NSString *)titleString andTag:(int)_tag;

@end

@interface Spinner : UIView {
	NSMutableArray* pData;
	NSString* title;
    
	UIView* supView;
	UIView* view;
    
	UIButton* pBtnLeft;
	UIButton* pBtnCenter;
	UIButton* pBtnRight;
    
    id<sendTitleDelegate> delegate;
    
}

@property (nonatomic, readonly) NSMutableArray* pData;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, assign) id<sendTitleDelegate> delegate;
@property (nonatomic, assign) int isClick;

//- (id)initWithX:(int)x Y:(int)y Width:(int)width data:(NSMutableArray*)dataArray view:(UIView*)rootView;
- (id)initWithFrame:(CGRect)frame data:(NSMutableArray *)dataArray view:(UIView*)rootView;

//- (void)btnClicked;
- (void)btnItemClicked: (id)sender;
- (void)showList;

- (void)hiddenView;

@end
