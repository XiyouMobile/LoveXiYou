//
//  CourseViewController.h
//  LoveXiYou
//
//  Created by  on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DisclosureDetailViewController.h"
#import <PlausibleDatabase/PlausibleDatabase.h>
#import "Database.h"
#import "Lession.h"
#import "Spinner.h"


//@protocol courseViewDelegate <NSObject>
//
//- (void)passSection:(NSUInteger)section;
//
//@end

@interface CourseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DisclosurePassValueDelegate,UIApplicationDelegate,sendTitleDelegate>{
    
    Spinner          *spinner;
    NSMutableArray   *currentArray;
    
    NSString         *subject;
    NSString         *teacher;
    NSString         *address;
    NSString         *beizhu;
    
    NSInteger         day;
    NSInteger         Cday;
    NSUInteger        tag;
    NSUInteger        tagFather;
    NSMutableArray   *arr;
    Lession          *getarr;
    
    BOOL              finished;
    CGPoint           startPoint;
    NSUInteger        pointCount;
    NSUInteger        touchtype;
    
    UITableView      *courseTableView;
    
    
    DisclosureDetailViewController *disclosureView;
    
    BOOL isHidden;
}

@property (nonatomic, strong) NSMutableArray  *currentArray;

@property (nonatomic, retain) NSString        *subject;
@property (nonatomic, retain) NSString        *teacher;
@property (nonatomic, retain) NSString        *address;
@property (nonatomic, retain) NSString        *beizhu;

@property (nonatomic)         NSInteger        day;
@property (nonatomic)         NSInteger        Cday;
@property (nonatomic)         NSUInteger       tag;
@property (nonatomic)         NSUInteger       tagFather;
@property (nonatomic, strong) NSMutableArray  *arr;
@property (nonatomic, strong) Lession         *getarr;

@property (nonatomic, retain) UITableView     *courseTableView;

@property (nonatomic, readwrite) CGPoint       startPoint;

@property (nonatomic, retain) DisclosureDetailViewController *disclosureView;


- (void)reloadViewData;
//- (void)performTransitionLeft:(UIView *)View;
//- (void)performTransitionRight:(UIView *)View;
@end
