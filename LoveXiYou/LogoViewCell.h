//
//  LogoViewCell.h
//  LoveXiYou
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 MyCompanyName. All rights reserved.
//

#import <UIKit/UIKit.h>

//按钮tag协议
@protocol cellItemDelegate

@optional
- (void)onCellItem:(int)index;

@end

@interface LogoViewCell : UITableViewCell {
    UIButton *_leftBtn;        //左边的logo按钮
    UIButton *_middleBtn;      //中间的logo按钮
    UIButton *_rightBtn;       //右边的logo按钮
    UILabel  *_leftLabel;      //左边的logo标签
    UILabel  *_middleLabel;    //中间的logo标签
    UILabel  *_rightLabel;     //右边的logo标签
    
    id<cellItemDelegate> _delegate;
}

@property (nonatomic, retain) UIButton *leftBtn;
@property (nonatomic, retain) UIButton *middleBtn;
@property (nonatomic, retain) UIButton *rightBtn;
@property (nonatomic, retain) UILabel  *leftLabel;
@property (nonatomic, retain) UILabel  *middleLabel;
@property (nonatomic, retain) UILabel  *rightLabel;

@property (assign) id<cellItemDelegate> delegate;

@end


