//
//  Spinner.m
//  Spinner
//
//  Created by 软件业务 on 11-4-1.
//  Copyright 2011 huitu.com.cn. All rights reserved.
//

#import "Spinner.h"


@implementation Spinner

@synthesize pData;
@synthesize title;
@synthesize delegate;
@synthesize isClick;

- (id)initWithFrame:(CGRect)frame data:(NSMutableArray *)dataArray view:(UIView*)rootView{
    if (frame.size.width < 50) {
        frame.size.width = 50;
    }
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        pData = dataArray;
		if (pData == nil) {
			pData = [NSMutableArray arrayWithCapacity:0];
		}
		[pData retain];
        
        supView = rootView;
        [supView retain];
        
    }
    return self;
}

- (void)showList{
    int num=[pData count];
	if (num>0) {
		if (num>5) {
			num=5;
		}
		int hy=[pData count]*60 + ([pData count]-1)*1;
		
		view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		[view setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3]];
		
		UIView* dataView;
		UIScrollView* mainView;
		
        //dataView为整个列表视图
		dataView=[[UIView alloc] initWithFrame:CGRectMake(11, (351-61*num)/2, 298, 61*num+15)];
		UIButton* btnTop=[[UIButton alloc] initWithFrame: CGRectMake(0, 0, 298, 8)];
		[btnTop setBackgroundImage:[UIImage imageNamed:@"邮电绿色弹出框边界"] forState:UIControlStateNormal];
		[btnTop setAlpha:1.0];
		[dataView addSubview:btnTop];
		[btnTop release];
		UIButton* btnBottom=[[UIButton alloc] initWithFrame: CGRectMake(0, 61*num+7, 298, 8)];
		[btnBottom setBackgroundImage:[UIImage imageNamed:@"邮电绿色弹出框边界"] forState:UIControlStateNormal];
		[btnBottom setAlpha:1.0];
		[dataView addSubview:btnBottom];
		[btnBottom release];
		
		mainView=[[UIScrollView alloc] initWithFrame: CGRectMake(0, 8, 298, 61*num-1)];
		[mainView setContentSize:CGSizeMake(298, hy)];
		[mainView setBackgroundColor:[UIColor whiteColor]];
		
		UIButton* button;
		UILabel* label;
		for (int i=0; i<[pData count]; i++) {
			button=[[UIButton alloc] initWithFrame:CGRectMake(0, 61*i, 298, 59)];
			[button setBackgroundColor:[UIColor whiteColor]];
            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"邮电绿色弹出框中间"]];
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[button setTitle:[NSString stringWithFormat:@"%@",[pData objectAtIndex:i]] forState:UIControlStateNormal];
			[button setTag:i];
			[button addTarget:self action:@selector(btnItemClicked:) forControlEvents:UIControlEventTouchUpInside];
			[mainView addSubview:button];
			[button release];
			
			if (i<[pData count]-1) {
				label=[[UILabel alloc] initWithFrame:CGRectMake(0, 61*(i+1)-1, 298, 2)];
				[label setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3]];
				[mainView addSubview:label];
				[label release];
			}
		}
		
		[dataView addSubview:mainView];
		[mainView release];
		[view addSubview:dataView];
		[dataView release];
		
		[supView addSubview:view];
	}
    
    
}

- (void)btnItemClicked:(id)sender{
	UIButton* button=(UIButton*)sender;
	int index=[button tag];
    self.title = [NSString stringWithFormat:@"%@", [pData objectAtIndex:index]];
	[self hiddenView];
    [delegate sendTitle:self.title andTag:index];
    
}

- (void)hiddenView{
    [view removeFromSuperview];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
	[pData release];
    pData = nil;
	[self.title release];
    self.title = nil;
	//[view release];
    //view = nil;
	[supView release];
    supView = nil;
    delegate = nil;
	
    [super dealloc];
}


@end
