//
//  LogoCrossViewCell.h
//  LoveXiYou
//
//  Created by  on 12-5-15.
//  Copyright (c) 2012年 MyCompanyName. All rights reserved.
//

#import <UIKit/UIKit.h>

//按钮tag协议
@protocol cellItemCrossDelegate

@optional
- (void)onCellItem:(int)index;

@end

@interface LogoCrossViewCell : UITableViewCell{
    UIButton *_leftCrossBtn;        //左边的logo按钮
    UIButton *_middleCrossBtn;      //中间的logo按钮
    UIButton *_rightCrossBtn;       //右边的logo按钮
    UILabel  *_leftCrossLabel;      //左边的logo标签
    UILabel  *_middleCrossLabel;    //中间的logo标签
    UILabel  *_rightCrossLabel;     //右边的logo标签

    id<cellItemCrossDelegate> _delegate;
}

@property (nonatomic, retain) UIButton *leftCrossBtn;
@property (nonatomic, retain) UIButton *middleCrossBtn;
@property (nonatomic, retain) UIButton *rightCrossBtn;
@property (nonatomic, retain) UILabel  *leftCrossLabel;
@property (nonatomic, retain) UILabel  *middleCrossLabel;
@property (nonatomic, retain) UILabel  *rightCrossLabel;

@property (assign) id<cellItemCrossDelegate> delegate;

@end
