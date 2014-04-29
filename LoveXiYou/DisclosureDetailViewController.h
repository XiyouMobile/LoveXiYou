//
//  DisclosureDetailController.h
//  LoveXiYou
//
//  Created by iphone2 on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Database.h"


@protocol DisclosurePassValueDelegate

- (void)passSubject:(NSString *)value1 andTeacher:(NSString *)value2 andAddress:(NSString *)value3 andBeizhu:(NSString *)value4 andFlag:(NSInteger)flag andFlagFather:(NSInteger)flagFather andCday:(NSInteger)Cday;
- (void) reloadViewData;
@end

@interface DisclosureDetailViewController : UITableViewController<UITextFieldDelegate,UISplitViewControllerDelegate>{
    
    NSArray *content1;
    NSArray *content2;
    NSArray *content3;
    NSArray *content4;
    
    UITextField *subjectField;
    UITextField *teacherField;
    UITextField *addressField;
    UITextField *beizhuField;
    
    id<DisclosurePassValueDelegate> delegate;
    
    NSString *courseSubject;
    NSString *courseTeacher;
    NSString *courseAddress;
    NSString *courseBeizhu;
    NSString *string;
    
    NSInteger flag;
    NSInteger flagFather;
    
    NSInteger Cday;
    
    //TalkViewController *talkView;
    
}

@property (nonatomic, retain) NSArray *content1;

@property (nonatomic, retain) UITextField *subjectField;
@property (nonatomic, retain) UITextField *teacherField;
@property (nonatomic, retain) UITextField *addressField;
@property (nonatomic, retain) UITextField *beizhuField;

@property (nonatomic,assign) id<DisclosurePassValueDelegate>delegate;

@property (nonatomic, retain) NSString *courseSubject;
@property (nonatomic, retain) NSString *courseTeacher;
@property (nonatomic, retain) NSString *courseAddress;
@property (nonatomic, retain) NSString *courseBeizhu;
@property (nonatomic, retain) NSString *string;

@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger Cday;

@property (nonatomic) NSInteger flag;
@property (nonatomic) NSInteger flagFather;



- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backTo:(id)sender;
- (IBAction)saveTo:(id)sender;


@end




