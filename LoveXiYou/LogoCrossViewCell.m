//
//  LogoCrossViewCell.m
//  LoveXiYou
//
//  Created by  on 12-5-15.
//  Copyright (c) 2012年 MyCompanyName. All rights reserved.
//

#import "LogoCrossViewCell.h"

@implementation LogoCrossViewCell

@synthesize leftCrossBtn = _leftCrossBtn;
@synthesize middleCrossBtn =_middleCrossBtn;
@synthesize rightCrossBtn = _rightCrossBtn;
@synthesize leftCrossLabel = _leftCrossLabel;
@synthesize middleCrossLabel = _middleCrossLabel;
@synthesize rightCrossLabel = _rightCrossLabel;

@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        self.leftCrossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftCrossBtn.frame = CGRectMake(49, 20, 48, 48);
        [self.leftCrossBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];    
        [self addSubview:self.leftCrossBtn];
        
        self.leftCrossLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 76, 42, 21)];
        self.leftCrossLabel.textAlignment = UITextAlignmentCenter;
        self.leftCrossLabel.font = [UIFont systemFontOfSize:10];
        self.leftCrossLabel.text = @"题标";        
       // leftCrossLabel= leftCrossLabel;
        [self addSubview:self.leftCrossLabel];
        
        
        self.middleCrossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.middleCrossBtn.frame = CGRectMake(223, 20, 48, 48);
        [self.middleCrossBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.middleCrossBtn];
        
        self.middleCrossLabel = [[UILabel alloc] initWithFrame:CGRectMake(226, 76, 42, 21)];
        self.middleCrossLabel.textAlignment = UITextAlignmentCenter;
        self.middleCrossLabel.font = [UIFont systemFontOfSize:10];
        self.middleCrossLabel.text = @"题标";
        [self addSubview:self.middleCrossLabel];
        
        
        self.rightCrossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightCrossBtn.frame = CGRectMake(381, 20, 48, 48);
        [self.rightCrossBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightCrossBtn];
        
        self.rightCrossLabel = [[UILabel alloc] initWithFrame:CGRectMake(384, 76, 42, 21)];
        self.rightCrossLabel.textAlignment = UITextAlignmentCenter;
        self.rightCrossLabel.font = [UIFont systemFontOfSize:10];
        self.rightCrossLabel.text = @"题标";
        [self addSubview:self.rightCrossLabel];
        
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
    [_leftCrossBtn release];
    _leftCrossBtn = nil;
    [_middleCrossBtn release];
    _middleCrossBtn = nil;
    [_rightCrossBtn release];
    _rightCrossBtn = nil;
    [_leftCrossLabel release];
    _leftCrossLabel = nil;
    [_middleCrossLabel release];
    _middleCrossLabel = nil;
    [_rightCrossLabel release];
    _rightCrossLabel = nil;
    _delegate = nil;
    [super dealloc];
}

@end
