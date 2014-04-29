//
//  MoreViewController.h
//  LoveXiYou
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userResponseController.h"
#import "MobClick.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "CloNetworkUtil.h"

@interface MoreViewController : UIViewController< MFMailComposeViewControllerDelegate>{
    IBOutlet UIScrollView   *scrollView;
    IBOutlet UISlider       *sizeSlider;
    IBOutlet UIImageView    *aboutUsBg,*updateBg,*userResponseBg,*moreViewBg,*userManageBg;
}
@property(nonatomic, retain) UIScrollView *scrollView;
@property(nonatomic, retain) UISlider     *sizeSlider;
@property(nonatomic, retain) UIImageView    *aboutUsBg,*updateBg,*userResponseBg,*moreViewBg,*userManageBg;
@end
