//
//  showBook.h
//  http2
//
//  Created by  on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "TFHpple.h"
#import "MobClick.h"

@protocol showBookDelegate <NSObject>
-(NSString *)bookListRequest;
@end

@interface showBook : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    NSInteger index;
    UITableView *myTableView;
    NSString *bookListString;
    NSDictionary *book;
    NSArray *bookArr;
    id<showBookDelegate> delegate;
    
}

@property (nonatomic, retain) NSString *bookListString;
@property (nonatomic, retain) NSArray *bookArr;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, assign) id<showBookDelegate> delegate;

-(void)       Request;
-(void)       remind:(NSString *) htmlData;
-(void)       done:(id)sender;
-(void)       showAlert:(NSString *)message;
-(void)       renewing:(id)sender;
-(NSDate *)   stringToDate:(NSString *)aString;
-(NSUInteger) compareCurrentTime:(NSDate*) compareDate;
-(void)       locationAlert;
@end
