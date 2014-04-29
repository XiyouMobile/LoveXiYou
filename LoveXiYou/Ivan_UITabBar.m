//
//  Ivan_UITabBar.m
//  JustForTest
//
//  Created by Ivan on 11-5-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Ivan_UITabBar.h"
#import "UIBadgeView.h"

@implementation Ivan_UITabBar
@synthesize currentSelectedIndex;
@synthesize buttons;

static BOOL FIRSTTIME =YES;


- (void)viewDidAppear:(BOOL)animated{
	if (FIRSTTIME) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideCustomTabBar" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(hideCustomTabBar)
													 name: @"hideCustomTabBar"
												   object: nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"bringCustomTabBarToFront" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(bringCustomTabBarToFront)
													 name: @"bringCustomTabBarToFront"
												   object: nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"setBadge" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(setBadge:)
													 name: @"setBadge"
												   object: nil];
		
		slideBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide"]];
		[self hideRealTabBar];
		[self customTabBar];
		FIRSTTIME = NO;
	}
}

//设置和隐藏TabBar
-(void)isHideTabBar:(BOOL)isNO{

    if (isNO) {
        
        [self performSelector:@selector(bringCustomTabBarToFront)];
        
    }else{
    
        [self performSelector:@selector(hideCustomTabBar)];
    
    }

}
- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}

//设置badge
- (void)setBadge:(NSNotification *)_notification{
	NSString *badgeValue = [_notification object];
	UIButton *btn = [self.buttons objectAtIndex:self.selectedIndex];
	UIBadgeView *badgeView = [[UIBadgeView alloc] initWithFrame:CGRectMake(btn.bounds.size.width/2, 0, 30, 20)];
	badgeView.badgeString = badgeValue;
	badgeView.badgeColor = [UIColor blueColor];
	badgeView.tag = self.selectedIndex;
	badgeView.delegate = self;
	[btn addSubview:badgeView];
	[badgeView release];
}

//自定义tabbar
- (void)customTabBar{
	//获取tabbar的frame
	CGRect tabBarFrame = self.tabBar.frame;
	backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
	cusTomTabBarView = [[UIView alloc] initWithFrame:tabBarFrame];
	//设置tabbar背景
	
	//backGroundImageView.image = [UIImage imageNamed:@"banner.png"];
	[cusTomTabBarView addSubview:backGroundImageView];
	[backGroundImageView release];
	cusTomTabBarView.backgroundColor = [UIColor blackColor];
	
	
	//创建按钮
	int viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
	double _width = 320 / viewCount;
	double _height = self.tabBar.frame.size.height;
	for (int i = 0; i < viewCount; i++) {
		UIViewController *v = [self.viewControllers objectAtIndex:i];
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectMake(i*_width, 0, _width, _height);
		[btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchDown];
		btn.tag = i;
//        slideBg.image=[UIImage imageNamed:[NSString stringWithFormat:@"tabbar%i",btn.tag+6]];
        
//        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar%i",btn.tag+1]] forState:UIControlStateNormal];
		[btn setBackgroundImage:v.tabBarItem.image forState:UIControlStateNormal];
		[btn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
		//添加标题
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _height-18, _width, _height-30)];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.text = v.tabBarItem.title;
		[titleLabel setFont:[UIFont systemFontOfSize:12]];
		titleLabel.textAlignment = 1;
		titleLabel.textColor = [UIColor whiteColor];
		[btn addSubview:titleLabel];
		[titleLabel release];		
		
		[self.buttons addObject:btn];
//		//添加按钮之间的分割线,第一个位置和最后一个位置不需要添加
//		if (i>0 && i<4) {
//			UIImageView *splitView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"split"]];
//			splitView.frame = CGRectMake(i*_width-1,0,splitView.frame.size.width,splitView.frame.size.height);
//			[cusTomTabBarView addSubview:splitView];
//			[splitView release];
//		}
		
		//添加Badge
		if (v.tabBarItem.badgeValue) {
			UIBadgeView *badgeView = [[UIBadgeView alloc] initWithFrame:CGRectMake(_width/2, 0, 30, 20)];
			badgeView.badgeString = v.tabBarItem.badgeValue;
			badgeView.badgeColor = [UIColor orangeColor];
			[btn addSubview:badgeView];
			[badgeView release];
		}
		[cusTomTabBarView addSubview:btn];
	}
	[self.view addSubview:cusTomTabBarView];
	[cusTomTabBarView addSubview:slideBg];
	[cusTomTabBarView release];
	[self performSelector:@selector(slideTabBg:) withObject:[self.buttons objectAtIndex:0]];
}

//切换tabbar
- (void)selectedTab:(UIButton *)button{
	if (self.currentSelectedIndex == button.tag) {
		[[self.viewControllers objectAtIndex:button.tag] popToRootViewControllerAnimated:YES];
		return;
	}
	self.currentSelectedIndex = button.tag;
	self.selectedIndex = self.currentSelectedIndex;
	[self performSelector:@selector(slideTabBg:) withObject:button];
}

//将自定义的tabbar显示出来
- (void)bringCustomTabBarToFront{
    NSLog(@"bringCustomTabBarToFront-----");
    [self performSelector:@selector(hideRealTabBar)];
    [cusTomTabBarView setHidden:NO];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35];
	//[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	cusTomTabBarView.frame=CGRectMake(0, cusTomTabBarView.frame.origin.y, 320, 50);
    //    cusTomTabBarView.center=CGPointMake(320, cusTomTabBarView.center.y);
    
	[UIView commitAnimations];

    

}

//隐藏自定义tabbar
- (void)hideCustomTabBar{
    NSLog(@"hideCustomTabBar----");
	[self performSelector:@selector(hideRealTabBar)];
    
    
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35];
	//[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	cusTomTabBarView.frame=CGRectMake(-320, cusTomTabBarView.frame.origin.y, 320, 50);
    //    cusTomTabBarView.center=CGPointMake(320, cusTomTabBarView.center.y);
    
	[UIView commitAnimations];
    

    
    
}

//动画结束回调
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (anim.duration==0.1) {
        [cusTomTabBarView setHidden:YES];
    }
}

//切换滑块位置
- (void)slideTabBg:(UIButton *)btn{
    
    switch (btn.tag) {
        case 0:
            
            slideBg.image=[UIImage imageNamed:@"邮电绿色标签栏_首页阴影@2x.png"];
            
            break;
        case 1:
            slideBg.image=[UIImage imageNamed:@"邮电绿色标签栏_校园阴影@2x.png"];
            break;
        case 2:
            slideBg.image=[UIImage imageNamed:@"邮电绿色标签栏_课程表阴影@2x.png"];
            break;
        case 3:
            slideBg.image=[UIImage imageNamed:@"邮电绿色标签栏_更多阴影@2x.png"];
            break;
            
        default:
            break;
    }
    
    
    
	slideBg.frame = btn.frame;
//    slideBg.backgroundColor=[UIColor redColor];
    
    
//	[UIView beginAnimations:nil context:nil];  
//	[UIView setAnimationDuration:0.20];  
//	[UIView setAnimationDelegate:self];
//	slideBg.frame = btn.frame;
//	[UIView commitAnimations];
//	CAKeyframeAnimation * animation; 
//	animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"]; 
//	animation.duration = 0.50; 
//	animation.delegate = self;
//	animation.removedOnCompletion = YES;
//	animation.fillMode = kCAFillModeForwards;
//	NSMutableArray *values = [NSMutableArray array];
//	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]]; 
//	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]]; 
//	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//	animation.values = values;
//	[btn.layer addAnimation:animation forKey:nil];
}


- (void) dealloc{
	
	[cusTomTabBarView release];
	[slideBg release];
	[buttons release];
	[backGroundImageView release];
	[super dealloc];
}


@end
