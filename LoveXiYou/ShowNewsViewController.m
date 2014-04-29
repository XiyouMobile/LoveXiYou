//
//  ShowNewsViewController.m
//  LoveXiYou
//
//  Created by  on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShowNewsViewController.h"
#import "UIViewController+AddTitleView.h"

@implementation ShowNewsViewController

@synthesize titleString = _titleString;
@synthesize hrefString = _hrefString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//初始化controller,设置viewTag
- (id)initWithTag:(int)_viewTag{
    self = [super init];
    if (self) {
        
        viewTag = _viewTag;
        
        arrayFlag = 0;
        
    }
    return  self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc{
    [_titleString release];
    _titleString = nil;
    [_hrefString release];
    _hrefString = nil;
    [contentString release];
    contentString = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:15.0];
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
    
    [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航返回按钮" Event:@selector(backTo:)];
    
    NSLog(@"titleString:%@,hrefString:%@",_titleString,_hrefString);
    
    contentString = [[NSMutableString alloc] initWithFormat:@"%@\n",_titleString];
    NSLog(@"contentString:%@",contentString);
    
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textView.text = [NSString stringWithFormat:@"%@",[self XPathParsing]];
    [self.view addSubview:textView];
    [textView release];
    
}

- (void)backTo:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)XPathParsing{
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    
    // 得到网页DATA
    NSString *urlString = nil;
    urlString = [NSString stringWithFormat:@"%@",_hrefString];
    
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSData *toHtmlData = [self toUtf8:htmlData];
    
    TFHpple *xpathParser = nil;
    NSArray *aArray = nil;
    
    if (viewTag == 1 || viewTag == 2) {
        xpathParser = [[TFHpple alloc] initWithHTMLData:toHtmlData];
        aArray = [[NSArray alloc] initWithArray:[xpathParser searchWithXPathQuery:@"//p[@class='MsoNormal']"]];
        NSLog(@"aArrayCount:%d,aArray:%@",[aArray count],aArray);
    }
    
    if (viewTag == 0) {
        //xpathParser = [[TFHpple alloc] initWithHTMLData:toHtmlData];
        xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
        //aArray = [[NSArray alloc] initWithArray:[xpathParser searchWithXPathQuery:@"//p/span"]];
        aArray = [[NSArray alloc] initWithArray:[xpathParser searchWithXPathQuery:@"//div/span"]];
        NSLog(@"aArrayCount:%d,aArray:%@",[aArray count],aArray);
        
        if ([aArray count] <= 4) {
            [aArray release];
            aArray = nil;
            aArray = [[NSArray alloc] initWithArray:[xpathParser searchWithXPathQuery:@"//p/span"]];
            NSLog(@"aArrayCount:%d,aArray:%@",[aArray count],aArray);
            arrayFlag = 1;
        }
    }
    
    if ([aArray count] > 0) {
        
        int i;
        if (arrayFlag == 0) {
            i = 2;
        }else {
            i = 0;
        }
        
        for (; i < [aArray count]; i++) {
            TFHppleElement *aElement = [aArray objectAtIndex:i];
            NSArray *aElementArr = [aElement children];
            NSLog(@"aElementArrCount:%d,aElementArr:%@",[aElementArr count],aElementArr);
            if ([aElementArr count]> 0) {
                for (int j = 0; j < [aElementArr count]; j++) {
                    TFHppleElement *aFirstElement = [aElementArr objectAtIndex:j];
                    NSArray *aFirstChildArray = [aFirstElement children];
                    NSLog(@"aFirstChildArrayCount:%d,aFirstChildArray:%@",[aFirstChildArray count],aFirstChildArray);
                    
                    if ([aFirstChildArray count] > 0) {
                        for (int k = 0; k < [aFirstChildArray count]; k++) {
                            
                            [self contentArray:aFirstChildArray contentCount:k];
                            
                        }
                    }
                    else {
                        NSString *aStr = [aFirstElement content];
                        if (aStr != nil) {
                            [contentString appendString:aStr];
                    //        [contentString appendFormat:[NSString stringWithFormat:@"%@",aStr]];
                            NSLog(@"contentString:%@",contentString);
                            NSLog(@"aStr:%@",aStr);
                        }
                    }
                    
                }
            }
            else {
                NSString *aStr = [aElement content];
                if (aStr != nil) {
                    [contentString appendString:aStr];
                 //   [contentString appendFormat:[NSString stringWithFormat:@"%@",aStr]];
                    NSLog(@"contentString:%@",contentString);
                    NSLog(@"aStr:%@",aStr);
                }
            }
        }
    }
    [xpathParser release];
    xpathParser = nil;
    
    [htmlData release];
    htmlData = nil;
    
    [aArray release];
    aArray = nil;
    
    [SVProgressHUD dismiss];
    
    return contentString;
    
}

//递归实现，解析公告或新闻内容
- (void)contentArray:(NSArray *)_array contentCount:(int)_count{
    TFHppleElement *aSecondElement = [_array objectAtIndex:_count];
    NSArray *aSecondChildArray = [aSecondElement children];
    NSLog(@"aSecondChildArrayCount:%d,aSecondChildArray:%@",[aSecondChildArray count],aSecondChildArray);
    if ([aSecondChildArray count] > 0) {
        for (int count = 0; count < [aSecondChildArray count]; count++) {
            
            [self contentArray:aSecondChildArray contentCount:count];
            
        }
    }
    else {
        NSString *aStr = [aSecondElement content];
        if (aStr != nil) {
            [contentString appendString:aStr];
            NSLog(@"contentString:%@",contentString);
            NSLog(@"aStr:%@",aStr);
        }
    }
}

- (NSData *) toUtf8:(NSData *)inData {  
    CFStringRef gbkStr = CFStringCreateWithBytes(NULL, [inData bytes], [inData length], kCFStringEncodingGB_18030_2000, false);  
    
    if (NULL == gbkStr) {  
        return nil;  
    } else {  
        NSString *gbkStrTmp = (NSString *)gbkStr;  
        NSString *utf8NSString = [gbkStrTmp stringByReplacingOccurrencesOfString:@"META http-equiv=\"Content-Type\" content=\"text/html; charset=GBK\"" withString:@"META http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\""];  
        
        return [utf8NSString dataUsingEncoding:NSUTF8StringEncoding];                             
    }                                     
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
