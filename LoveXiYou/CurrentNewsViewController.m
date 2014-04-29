//
//  CurrentNewsViewController.m
//  LoveXiYou
//
//  Created by  on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CurrentNewsViewController.h"
#import "UIViewController+AddTitleView.h"
#import "ShowNewsViewController.h"
#import "ModalAlert.h"

#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@implementation CurrentNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)dealloc{
    [currentNewsTable release];
    currentNewsTable = nil;
    [currentNewsArray release];
    currentNewsArray = nil;
    [currentNewsArr release];
    currentNewsArr = nil;
    [currentHrefArr release];
    currentHrefArr = nil;
    [currentHrefArray release];
    currentHrefArray = nil;
//    [spinner release];
//    spinner = nil;
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
    
    isHidden = YES;
    
    [self setleftBarButtonItem:nil orImaged:@"邮电绿色导航返回按钮" Event:@selector(backTo:)];
    
    currentArray = [NSMutableArray arrayWithObjects:@"西邮新闻",@"西邮公告", @"学术公告", nil];
    
    currentNewsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
    currentNewsTable.delegate = self;
    currentNewsTable.dataSource = self;
    [self.view addSubview:currentNewsTable];
    
    [self setrightBarButtonItem:nil orImaged:@"邮电绿色导航新窗口按钮" Event:@selector(listTo:)];
    spinner = [[Spinner alloc] initWithFrame:CGRectMake(0, 0, 280, 352) data:currentArray view:self.view];
    spinner.delegate = self;
    NSLog(@"SPN Item: %@", spinner.title);
    self.title = @"西邮新闻";
    
    [self showList];
    
}

- (void)backTo:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//列表按钮响应事件，点击显示响应列表视图
- (void)listTo:(id)sender{
    if (isHidden == YES) {
        [spinner showList];
        isHidden = NO;
    }else {
        [spinner hiddenView];
        isHidden = YES;
    }
}


//从tag值判断是西邮简介还是院系列表，显示响应界面
- (void)showList{
    
    NSString *urlString = @"http://news.xupt.edu.cn/xinwenwang/xynews/";
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSLog(@"htmlData:%@",htmlData);
    if (![CloNetworkUtil getNetWorkStatus]) {
        [ModalAlert say:@"未连接网络\n请稍检查您的网络设置..."];
    }else {
        if (htmlData == nil) {
            [ModalAlert say:@"请求超时...\n请稍后进入..."];
        }else {
            [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
            
            currentNewsArr = [[NSMutableArray alloc] initWithCapacity:0];
            currentHrefArr = [[NSMutableArray alloc] initWithCapacity:0];
            
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
            
            //NSArray *li = [xpathParser searchWithXPathQuery:@"//div/ul/li/a[@class='blue']"];
            NSArray *li = [xpathParser searchWithXPathQuery:@"//div[@class='mar_10']/ul[@class='text_list text_list_f14']/li/a[@class='url']"];
            NSLog(@"liCount:%d,li:%@",[li count],li);
            if ([li count] > 0) {
                
                for (int i = 0; i < 20; i++) {
                    TFHppleElement *liEle = [li objectAtIndex:i];
                    NSArray *liArr = [liEle children];
                    NSLog(@"liArrCount:%d,liArr:%@",[liArr count],liArr);
                    for (int j = 0; j < [liArr count]; j++) {
                        TFHppleElement *liChildEle = [liArr objectAtIndex:j];
                        NSArray *liChildEleArray = [liChildEle children];
                        NSLog(@"liChildEleArrayCount:%d,liChildEleArray:%@",[liChildEleArray count],liChildEleArray);
                        if ([liChildEleArray count] > 0) {
                            for (int k = 0; k < [liChildEleArray count]; k++) {
                                TFHppleElement *liSecondChild = [liChildEleArray objectAtIndex:k];
                                NSArray *liSecondChildEleArray = [liChildEle children];
                                NSLog(@"liSecondChildEleArrayCount:%d,liSecondChildEleArray:%@",[liSecondChildEleArray count],liSecondChildEleArray);
                                if ([liSecondChildEleArray count] > 0) {
                                    for (int count = 0; count < [liSecondChildEleArray count]; count++) {
                                        TFHppleElement *liSecondChildEle = [liSecondChildEleArray objectAtIndex:0];
                                        NSString *liString = [liSecondChildEle content];
                                        NSLog(@"liString:%@",liString);
                                        NSDictionary *liAttributeDict = [liChildEle attributes];
                                        NSLog(@"liAttributeDict:%@",liAttributeDict);
                                        NSString *hrefStr = [NSString stringWithFormat:@"http://news.xiyou.edu.cn/xinwenwang/%@",[liAttributeDict objectForKey:@"href"]];
                                        NSLog(@"hrefStr:%@",hrefStr);
                                        [currentNewsArr addObject:liString];
                                        [currentHrefArr addObject:hrefStr];
                                    }
                                    
                                }
                                else {
                                    NSString *liString = [liSecondChild content];
                                    NSLog(@"liString:%@",liString);
                                    NSDictionary *liAttributeDict = [liEle attributes];
                                    NSLog(@"liAttributeDict:%@",liAttributeDict);
                                    NSString *hrefStr = [NSString stringWithFormat:@"http://news.xiyou.edu.cn/xinwenwang/%@",[liAttributeDict objectForKey:@"href"]];
                                    NSLog(@"hrefStr:%@",hrefStr);
                                    
                                    [currentNewsArr addObject:liString];
                                    [currentHrefArr addObject:hrefStr];
                                }
                            }
                            
                            
                        }
                        
                        else {
                            NSString *liString = [[liArr objectAtIndex:0] content];
                            NSLog(@"liString:%@",liString);
                            NSDictionary *liAttributeDict = [liEle attributes];
                            NSLog(@"liAttributeDict:%@",liAttributeDict);
                            NSString *hrefStr = [NSString stringWithFormat:@"http://news.xiyou.edu.cn/xinwenwang/%@",[liAttributeDict objectForKey:@"href"]];
                            NSLog(@"hrefStr:%@",hrefStr);
                            
                            [currentNewsArr addObject:liString];
                            [currentHrefArr addObject:hrefStr];
                        }
                    }
                    
                    
                }
                
                currentNewsArray = [[NSArray alloc] initWithArray:currentNewsArr];
                currentHrefArray = [[NSArray alloc] initWithArray:currentHrefArr];
                
            }
            
            [xpathParser release];
            xpathParser = nil;
            
            [htmlData release];
            htmlData = nil;
            
            [currentNewsTable reloadData];
            
            [SVProgressHUD dismiss];
            
        }

    }
        
}

#pragma delegate
#pragma spinnerDelegate
- (void)sendTitle:(NSString *)titleString andTag:(int)_tag{
    NSLog(@"SPN Item: %@", titleString);
    
    isHidden = YES;
    
    if (currentNewsArr != nil) {
        [currentNewsArr release];
        currentNewsArr = nil;
    }
    
    if (currentNewsArray != nil) {
        [currentNewsArray release];
        currentNewsArray = nil;
    }
    
    if (currentHrefArr != nil) {
        [currentHrefArr release];
        currentHrefArr = nil;
    }
    
    if (currentHrefArray != nil) {
        [currentHrefArray release];
        currentHrefArray = nil;
    }
    
    //[self showListContent:_tag];
    // 得到网页DATA
    NSString *urlString = nil;
    
     viewTag = _tag;
    
    switch (_tag) {
            
        case 0:
            self.title = @"西邮新闻";
            urlString = @"http://news.xupt.edu.cn/xinwenwang/xynews/";
            break;
        case 1:
            self.title = @"西邮公告";
            urlString = @"http://202.117.128.8/new/lm.jsp?urltype=tree.TreeTempUrl&wbtreeid=724";
            break;
        case 2:
            self.title = @"学术公告";
            urlString = @"http://202.117.128.8/new/lm.jsp?urltype=tree.TreeTempUrl&wbtreeid=725";
            break;
        
        default:
            break;
    }
    
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSLog(@"htmlData:%@",htmlData);
    if (![CloNetworkUtil getNetWorkStatus]) {
        [ModalAlert say:@"未连接网络\n请稍检查您的网络设置..."];
    }else if (htmlData == nil) {
        [ModalAlert say:@"服务器正在维护中...\n请稍后进入..."];
    }else {
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
        
        NSData *toHtmlData = [self toUtf8:htmlData];
        
        currentNewsArr = [[NSMutableArray alloc] initWithCapacity:0];
        currentHrefArr = [[NSMutableArray alloc] initWithCapacity:0];
        
        if (_tag == 1 || _tag == 2) {
            
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:toHtmlData];
            
            NSArray *aArray = [xpathParser searchWithXPathQuery:@"//a[@class='f456']"];
            NSLog(@"aArrayCount:%d,aArray:%@",[aArray count],aArray);
            if ([aArray count] > 0) {
                
                for (int i = 0; i < 15; i++) {
                    TFHppleElement *aElement = [aArray objectAtIndex:i];
                    NSArray *aArr = [aElement children];
                    TFHppleElement *aEle = [aArr objectAtIndex:0];
                    NSArray *aChild = [aEle children];
                    TFHppleElement *aChildEle = [aChild objectAtIndex:0];
                    NSArray *aChildren = [aChildEle children];
                    NSString *aStr = [[aChildren objectAtIndex:0] content];
                    NSLog(@"aStr:%@",aStr);
                    NSDictionary *aAttributeDict = [aElement attributes];
                    NSLog(@"aAttributeDict:%@",aAttributeDict);
                    
                    NSString *hrefStr = [NSString stringWithFormat:@"http://202.117.128.8%@",[aAttributeDict objectForKey:@"href"]];
                    NSLog(@"hrefStr:%@",hrefStr);
                    NSString *titleStr = [NSString stringWithFormat:@"%@",[aAttributeDict objectForKey:@"title"]];
                    NSLog(@"titleStr:%@",titleStr);
                    
                    [currentNewsArr addObject:aStr];
                    [currentHrefArr addObject:hrefStr];
                    
                }
                
                currentNewsArray = [[NSArray alloc] initWithArray:currentNewsArr];
                currentHrefArray = [[NSArray alloc] initWithArray:currentHrefArr];
                
            }
            
            [xpathParser release];
            xpathParser = nil;
            
        }else {
            
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
            
           // NSArray *li = [xpathParser searchWithXPathQuery:@"//div/ul/li/a[@class='blue']"];
            NSArray *li = [xpathParser searchWithXPathQuery:@"//div[@class='mar_10']/ul[@class='text_list text_list_f14']/li/a[@class='url']"];
            NSLog(@"liCount:%d,li:%@",[li count],li);
            if ([li count] > 0) {
                
                for (int i = 0; i < 20; i++) {
                    TFHppleElement *liEle = [li objectAtIndex:i];
                    NSArray *liArr = [liEle children];
                    NSLog(@"liArrCount:%d,liArr:%@",[liArr count],liArr);
                    for (int j = 0; j < [liArr count]; j++) {
                        TFHppleElement *liChildEle = [liArr objectAtIndex:j];
                        NSArray *liChildEleArray = [liChildEle children];
                        NSLog(@"liChildEleArrayCount:%d,liChildEleArray:%@",[liChildEleArray count],liChildEleArray);
                        if ([liChildEleArray count] > 0) {
                            for (int k = 0; k < [liChildEleArray count]; k++) {
                                TFHppleElement *liSecondChild = [liChildEleArray objectAtIndex:k];
                                NSArray *liSecondChildEleArray = [liChildEle children];
                                NSLog(@"liSecondChildEleArrayCount:%d,liSecondChildEleArray:%@",[liSecondChildEleArray count],liSecondChildEleArray);
                                if ([liSecondChildEleArray count] > 0) {
                                    for (int count = 0; count < [liSecondChildEleArray count]; count++) {
                                        TFHppleElement *liSecondChildEle = [liSecondChildEleArray objectAtIndex:0];
                                        NSString *liString = [liSecondChildEle content];
                                        NSLog(@"liString:%@",liString);
                                        NSDictionary *liAttributeDict = [liChildEle attributes];
                                        NSLog(@"liAttributeDict:%@",liAttributeDict);
                                        NSString *hrefStr = [NSString stringWithFormat:@"http://news.xiyou.edu.cn/xinwenwang/%@",[liAttributeDict objectForKey:@"href"]];
                                        NSLog(@"hrefStr:%@",hrefStr);
                                        [currentNewsArr addObject:liString];
                                        [currentHrefArr addObject:hrefStr];
                                    }
                                    
                                }
                                else {
                                    NSString *liString = [liSecondChild content];
                                    NSLog(@"liString:%@",liString);
                                    NSDictionary *liAttributeDict = [liEle attributes];
                                    NSLog(@"liAttributeDict:%@",liAttributeDict);
                                    NSString *hrefStr = [NSString stringWithFormat:@"http://news.xiyou.edu.cn/xinwenwang/%@",[liAttributeDict objectForKey:@"href"]];
                                    NSLog(@"hrefStr:%@",hrefStr);
                                    
                                    [currentNewsArr addObject:liString];
                                    [currentHrefArr addObject:hrefStr];
                                }
                            }
                            
                            
                        }
                        
                        else {
                            NSString *liString = [[liArr objectAtIndex:0] content];
                            NSLog(@"liString:%@",liString);
                            NSDictionary *liAttributeDict = [liEle attributes];
                            NSLog(@"liAttributeDict:%@",liAttributeDict);
                            NSString *hrefStr = [NSString stringWithFormat:@"http://news.xiyou.edu.cn/xinwenwang/%@",[liAttributeDict objectForKey:@"href"]];
                            NSLog(@"hrefStr:%@",hrefStr);
                            
                            [currentNewsArr addObject:liString];
                            [currentHrefArr addObject:hrefStr];
                        }
                    }
                    
                    
                }
                
                currentNewsArray = [[NSArray alloc] initWithArray:currentNewsArr];
                currentHrefArray = [[NSArray alloc] initWithArray:currentHrefArr];
                
            }
            
            [xpathParser release];
            xpathParser = nil;
        }
        
        [htmlData release];
        htmlData = nil;
        
        [currentNewsTable reloadData];
        
        [SVProgressHUD dismiss];
    }
    
}

- (void)showListContent:(int)_tag{
    
    if (currentNewsArr != nil) {
        [currentNewsArr release];
        currentNewsArr = nil;
    }
    
    if (currentNewsArray != nil) {
        [currentNewsArray release];
        currentNewsArray = nil;
    }
    
    if (currentHrefArr != nil) {
        [currentHrefArr release];
        currentHrefArr = nil;
    }
    
    if (currentHrefArray != nil) {
        [currentHrefArray release];
        currentHrefArray = nil;
    }

    
    NSString *urlString = nil;
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    //viewTag = _tag;
    
    switch (_tag) {
        case 0:
            self.title = @"西邮公告";
            urlString = @"http://www.xiyou.edu.cn/new/lm.jsp?urltype=tree.TreeTempUrl&wbtreeid=724";
            break;
        case 1:
            self.title = @"学术公告";
            urlString = @"http://www.xiyou.edu.cn/new/lm.jsp?urltype=tree.TreeTempUrl&wbtreeid=725";
            break;
        case 2:
            self.title = @"西邮新闻";
            urlString = @"http://news.xiyou.edu.cn/xinwenwang/list.php?catid=33";
            break;
        default:
            break;
    }
    
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSLog(@"htmlData:%@",htmlData);
    if (![CloNetworkUtil getNetWorkStatus]) {
        [ModalAlert say:@"未连接网络\n请稍检查您的网络设置..."];
    }else if (htmlData == nil) {
        [ModalAlert say:@"服务器正在维护中...\n请稍后进入..."];
    }else {
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
        
        NSData *toHtmlData = [self toUtf8:htmlData];
        
        currentNewsArr = [[NSMutableArray alloc] initWithCapacity:0];
        currentHrefArr = [[NSMutableArray alloc] initWithCapacity:0];
        
        if (_tag == 0 || _tag == 1) {
            
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:toHtmlData];
            
            NSArray *aArray = [xpathParser searchWithXPathQuery:@"//a[@class='f456']"];
            NSLog(@"aArrayCount:%d,aArray:%@",[aArray count],aArray);
            if ([aArray count] > 0) {
                
                for (int i = 0; i < 15; i++) {
                    TFHppleElement *aElement = [aArray objectAtIndex:i];
                    NSArray *aArr = [aElement children];
                    TFHppleElement *aEle = [aArr objectAtIndex:0];
                    NSArray *aChild = [aEle children];
                    TFHppleElement *aChildEle = [aChild objectAtIndex:0];
                    NSArray *aChildren = [aChildEle children];
                    NSString *aStr = [[aChildren objectAtIndex:0] content];
                    NSLog(@"aStr:%@",aStr);
                    NSDictionary *aAttributeDict = [aElement attributes];
                    NSLog(@"aAttributeDict:%@",aAttributeDict);
                    
                    NSString *hrefStr = [NSString stringWithFormat:@"http://www.xiyou.edu.cn%@",[aAttributeDict objectForKey:@"href"]];
                    NSLog(@"hrefStr:%@",hrefStr);
                    NSString *titleStr = [NSString stringWithFormat:@"%@",[aAttributeDict objectForKey:@"title"]];
                    NSLog(@"titleStr:%@",titleStr);
                    
                    [currentNewsArr addObject:aStr];
                    [currentHrefArr addObject:hrefStr];
                    
                }
                
                currentNewsArray = [[NSArray alloc] initWithArray:currentNewsArr];
                currentHrefArray = [[NSArray alloc] initWithArray:currentHrefArr];
                
            }
            
            [xpathParser release];
            xpathParser = nil;
            
        }else {
            
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
            
            NSArray *li = [xpathParser searchWithXPathQuery:@"//div/ul/li/a[@class='blue']"];
            NSLog(@"liCount:%d,li:%@",[li count],li);
            if ([li count] > 0) {
                
                for (int i = 0; i < 7; i++) {
                    TFHppleElement *liEle = [li objectAtIndex:i];
                    NSArray *liArr = [liEle children];
                    NSLog(@"liArrCount:%d,liArr:%@",[liArr count],liArr);
                    for (int j = 0; j < [liArr count]; j++) {
                        TFHppleElement *liChildEle = [liArr objectAtIndex:j];
                        NSArray *liChildEleArray = [liChildEle children];
                        NSLog(@"liChildEleArrayCount:%d,liChildEleArray:%@",[liChildEleArray count],liChildEleArray);
                        if ([liChildEleArray count] > 0) {
                            for (int k = 0; k < [liChildEleArray count]; k++) {
                                TFHppleElement *liSecondChild = [liChildEleArray objectAtIndex:k];
                                NSArray *liSecondChildEleArray = [liChildEle children];
                                NSLog(@"liSecondChildEleArrayCount:%d,liSecondChildEleArray:%@",[liSecondChildEleArray count],liSecondChildEleArray);
                                if ([liSecondChildEleArray count] > 0) {
                                    for (int count = 0; count < [liSecondChildEleArray count]; count++) {
                                        TFHppleElement *liSecondChildEle = [liSecondChildEleArray objectAtIndex:0];
                                        NSString *liString = [liSecondChildEle content];
                                        NSLog(@"liString:%@",liString);
                                        NSDictionary *liAttributeDict = [liChildEle attributes];
                                        NSLog(@"liAttributeDict:%@",liAttributeDict);
                                        NSString *hrefStr = [NSString stringWithFormat:@"http://news.xiyou.edu.cn/xinwenwang/%@",[liAttributeDict objectForKey:@"href"]];
                                        NSLog(@"hrefStr:%@",hrefStr);
                                        [currentNewsArr addObject:liString];
                                        [currentHrefArr addObject:hrefStr];
                                    }
                                    
                                }
                                else {
                                    NSString *liString = [liSecondChild content];
                                    NSLog(@"liString:%@",liString);
                                    NSDictionary *liAttributeDict = [liEle attributes];
                                    NSLog(@"liAttributeDict:%@",liAttributeDict);
                                    NSString *hrefStr = [NSString stringWithFormat:@"http://news.xiyou.edu.cn/xinwenwang/%@",[liAttributeDict objectForKey:@"href"]];
                                    NSLog(@"hrefStr:%@",hrefStr);
                                    
                                    [currentNewsArr addObject:liString];
                                    [currentHrefArr addObject:hrefStr];
                                }
                            }
                            
                            
                        }
                        
                        else {
                            NSString *liString = [[liArr objectAtIndex:0] content];
                            NSLog(@"liString:%@",liString);
                            NSDictionary *liAttributeDict = [liEle attributes];
                            NSLog(@"liAttributeDict:%@",liAttributeDict);
                            NSString *hrefStr = [NSString stringWithFormat:@"http://news.xiyou.edu.cn/xinwenwang/%@",[liAttributeDict objectForKey:@"href"]];
                            NSLog(@"hrefStr:%@",hrefStr);
                            
                            [currentNewsArr addObject:liString];
                            [currentHrefArr addObject:hrefStr];
                        }
                    }
                    
                    
                }
                
                currentNewsArray = [[NSArray alloc] initWithArray:currentNewsArr];
                currentHrefArray = [[NSArray alloc] initWithArray:currentHrefArr];
                
            }
            
            [xpathParser release];
            xpathParser = nil;
        }
        
        [htmlData release];
        htmlData = nil;
        
        [currentNewsTable reloadData];
        
        [SVProgressHUD dismiss];
    }
}



//将gbk编码转换为UTF-8编码
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

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [currentNewsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    //构建显示行
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
        
        [cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
        [cell.textLabel setMinimumFontSize:FONT_SIZE];
        [cell.textLabel setNumberOfLines:0];
        [cell.textLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [cell.textLabel setTag:1];
        
    }
    
    NSString *text = [currentNewsArray objectAtIndex:[indexPath row]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    [cell.textLabel setText:text];
    [cell.textLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowNewsViewController *showNewsController = [[ShowNewsViewController alloc] initWithTag:viewTag];
    showNewsController.titleString = [[NSString stringWithFormat:@"%@",[currentNewsArray objectAtIndex:indexPath.row]] copy];
    showNewsController.hrefString = [[NSString stringWithFormat:@"%@",[currentHrefArray objectAtIndex:indexPath.row]] copy];
    switch (viewTag) {
        case 0:
            showNewsController.title = @"西邮公告内容";
            break;
        case 1:
            showNewsController.title = @"学术公告内容";
            break;
        case 2:
            showNewsController.title = @"西邮新闻内容";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:showNewsController animated:YES];
    [showNewsController release];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [currentNewsArray objectAtIndex:[indexPath row]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

//添加索引的值，为右侧的A----Z 
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView  
{  
    return nil;
    //return keys; 
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
