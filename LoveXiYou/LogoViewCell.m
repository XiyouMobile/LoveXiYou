//
//  LogoViewCell.m
//  LoveXiYou
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 MyCompanyName. All rights reserved.
//

#import "LogoViewCell.h"

@implementation LogoViewCell

@synthesize leftBtn = _leftBtn;
@synthesize middleBtn = _middleBtn;
@synthesize rightBtn = _rightBtn;
@synthesize leftLabel = _leftLabel;
@synthesize middleLabel = _middleLabel;
@synthesize rightLabel = _rightLabel;

@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        // Initialization code
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame = CGRectMake(20, 12, 70, 70);
        [self.leftBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];  
        [self addSubview:self.leftBtn];
        
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 88, 80, 22)];
        self.leftLabel.textAlignment = UITextAlignmentCenter;
        self.leftLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.leftLabel];
        
        
        self.middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.middleBtn.frame = CGRectMake(125, 12, 70, 70);
        [self.middleBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.middleBtn];
        
        self.middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 88, 70, 22)];
        self.middleLabel.textAlignment = UITextAlignmentCenter;
        self.middleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.middleLabel];
        
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = CGRectMake(230, 12, 70, 70);
        [self.rightBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBtn];
        
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 88, 70, 22)];
        self.rightLabel.textAlignment = UITextAlignmentCenter;
        self.rightLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.rightLabel];
        
    }
    
    return self;
    
}

- (void)onClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSLog(@"tag:%d",button.tag);
    [self.delegate onCellItem:button.tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    [_leftBtn release];
    _leftBtn = nil;
    [_middleBtn release];
    _middleBtn = nil;
    [_rightBtn release];
    _rightBtn = nil;
    [_leftLabel release];
    _leftLabel = nil;
    [_middleLabel release];
    _middleLabel = nil;
    [_rightLabel release];
    _rightLabel = nil;
    _delegate = nil;
    [super dealloc];
}

@end
