//
//  BookViewController.h
//  LoveXiYou
//
//  Created by  on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "TFHpple.h"
#import "showBook.h"
#import "MobClick.h"

@interface BookViewController : UIViewController<showBookDelegate,UITextFieldDelegate>
{
    
    IBOutlet UITextField *userID;              //口令输入框
    IBOutlet UITextField *userKey;              //密码输入框
    NSArray *cookies;
    IBOutlet UIButton *okButton;
}

@property (nonatomic, retain) UITextField *userID;
@property (nonatomic, retain) UITextField *userKey;
@property (nonatomic, retain) NSArray *cookies;
@property (nonatomic, retain) UIButton *okButton;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSArray *bookInfo;

-(NSString *)bookListRequest; //第一次发送请求，判断登陆是否成功

-(void)ok; //登陆

@end
