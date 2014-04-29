//
//  userResponseController.h
//  LoveXiYou
//
//  Created by mobilephone xiyou on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface userResponseController : UIViewController<UITextViewDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>{
    IBOutlet UITextView  *suggestionText;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *responseWord;
}
@property(nonatomic, retain)UITextView  *suggestionText;
@property(nonatomic, retain)UITextField *emailField;
@property(nonatomic, retain)UITextField *responseWord;

- (void)backTo:(id)sender;
- (void)sendTo:(id)sender;
- (IBAction)emailEditBegin;
- (IBAction)emailEditEnd;
@end
