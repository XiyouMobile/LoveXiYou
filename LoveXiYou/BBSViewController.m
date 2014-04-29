//
//  BBSViewController.m
//  LoveXiYou
//
//  Created by  on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BBSViewController.h"
#import "UIViewController+AddTitleView.h"
#import "ShowNewsViewController.h"

#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@implementation BBSViewController

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

- (void)dealloc{
    [bbsNewsTable release];
    bbsNewsTable = nil;
    [bbsNewsArray release];
    bbsNewsArray = nil;
    [bbsNewsArr release];
    bbsNewsArr = nil;
    [bbsHrefArr release];
    bbsHrefArr = nil;
    [bbsHrefArray release];
    bbsHrefArray = nil;
    [spinner release];
    spinner = nil;
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
    
    [self setleftBarButtonItem:@"首页" orImaged:nil Event:@selector(backTo:)];
    
    bbsArray = [NSMutableArray arrayWithObjects:@"本周热门", @"跳蚤交易", @"最新帖子",nil];
    
    bbsNewsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStylePlain];
    bbsNewsTable.delegate = self;
    bbsNewsTable.dataSource = self;
    [self.view addSubview:bbsNewsTable];
    
    //bbsNewsArray = [[NSArray alloc] initWithArray:[self xpathParse:[self changeData:[self secondRequest]]]];
    [self showList];
    
    //[self HTMLParse];
}

- (void)backTo:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//列表按钮响应事件，点击显示响应列表视图
- (void)listTo:(id)sender{
    [spinner showList];
}

//从tag值判断是西邮简介还是院系列表，显示响应界面
- (void)showList{
    // viewTag = _viewTag;
    
    [self setrightBarButtonItem:@"bbs列表" orImaged:nil Event:@selector(listTo:)];
    spinner = [[Spinner alloc] initWithFrame:CGRectMake(0, 0, 280, 352) data:bbsArray view:self.view];
    spinner.delegate = self;
    NSLog(@"SPN Item: %@", spinner.title);
    self.title = @"本周热门";
    //int _tag = 0;
    
    //[self showListContent:_tag];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *urlString = @"http://www.xiyoubbs.com/home.php";
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSData *toHtmlData = [self toUtf8:htmlData];
    
    bbsNewsArr = [[NSMutableArray alloc] initWithCapacity:0];
    bbsHrefArr = [[NSMutableArray alloc] initWithCapacity:0];
    
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
            
            [bbsNewsArr addObject:aStr];
            [bbsHrefArr addObject:hrefStr];
            
        }
        
        bbsNewsArray = [[NSArray alloc] initWithArray:bbsNewsArr];
        bbsHrefArray = [[NSArray alloc] initWithArray:bbsHrefArr];
        
    }
    
    [xpathParser release];
    xpathParser = nil;
    
    [htmlData release];
    htmlData = nil;
    
    [bbsNewsTable reloadData];
    
    [SVProgressHUD dismiss];
    
}

#pragma delegate
#pragma spinnerDelegate
- (void)sendTitle:(NSString *)titleString andTag:(int)_tag{
    NSLog(@"SPN Item: %@", titleString);
    
    //[self showListContent:_tag];
    // 得到网页DATA
    NSString *urlString = nil;
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    viewTag = _tag;
    
    switch (_tag) {
        case 0:
            self.title = @"本周热门";
            //urlString = @"http://www.xiyou.edu.cn/new/lm.jsp?urltype=tree.TreeTempUrl&wbtreeid=724";
            urlString = @"http://www.xiyoubbs.com/home.php";    //家园
            break;
        case 1:
            self.title = @"跳蚤交易";
            //广场中的跳蚤交易
            urlString = @"http://www.xiyoubbs.com/forum.php?mod=forumdisplay&fid=27";
            break;
        case 2:
            self.title = @"最新帖子";
            //urlString = @"http://news.xiyou.edu.cn/xinwenwang/list.php?catid=33";
            //广场的查看新帖
            urlString = @"http://www.xiyoubbs.com/search.php?mod=forum&searchid=13&orderby=lastpost&ascdesc=desc&searchsubmit=yes&kw=";
            break;
        default:
            break;
    }
    
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSData *toHtmlData = [self toUtf8:htmlData];
    
    //bbsNewsArr = [[NSMutableArray alloc] initWithCapacity:0];
    //bbsHrefArr = [[NSMutableArray alloc] initWithCapacity:0];
    
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
                
                [bbsNewsArr addObject:aStr];
                [bbsHrefArr addObject:hrefStr];
                
            }
            
            bbsNewsArray = [[NSArray alloc] initWithArray:bbsNewsArr];
            bbsHrefArray = [[NSArray alloc] initWithArray:bbsHrefArr];
            
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
                                    [bbsNewsArr addObject:liString];
                                    [bbsHrefArr addObject:hrefStr];
                                }
                                
                            }
                            else {
                                NSString *liString = [liSecondChild content];
                                NSLog(@"liString:%@",liString);
                                NSDictionary *liAttributeDict = [liEle attributes];
                                NSLog(@"liAttributeDict:%@",liAttributeDict);
                                NSString *hrefStr = [NSString stringWithFormat:@"http://news.xiyou.edu.cn/xinwenwang/%@",[liAttributeDict objectForKey:@"href"]];
                                NSLog(@"hrefStr:%@",hrefStr);
                                
                                [bbsNewsArr addObject:liString];
                                [bbsHrefArr addObject:hrefStr];
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
                        
                        [bbsNewsArr addObject:liString];
                        [bbsHrefArr addObject:hrefStr];
                    }
                }
                
                
            }
            
            bbsNewsArray = [[NSArray alloc] initWithArray:bbsNewsArr];
            bbsHrefArray = [[NSArray alloc] initWithArray:bbsHrefArr];
            
        }
        
        [xpathParser release];
        xpathParser = nil;
    }
    
    [htmlData release];
    htmlData = nil;
    
    [bbsNewsTable reloadData];
    
    [SVProgressHUD dismiss];
    
}

- (void)showListContent:(int)_tag{
    
    NSString *urlString = nil;
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    viewTag = _tag;
    
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
    NSData *toHtmlData = [self toUtf8:htmlData];
    
    //bbsNewsArr = [[NSMutableArray alloc] initWithCapacity:0];
    //bbsHrefArr = [[NSMutableArray alloc] initWithCapacity:0];
    
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
                
                [bbsNewsArr addObject:aStr];
                [bbsHrefArr addObject:hrefStr];
                
            }
            
            bbsNewsArray = [[NSArray alloc] initWithArray:bbsNewsArr];
            bbsHrefArray = [[NSArray alloc] initWithArray:bbsHrefArr];
            
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
                                    [bbsNewsArr addObject:liString];
                                    [bbsHrefArr addObject:hrefStr];
                                }
                                
                            }
                            else {
                                NSString *liString = [liSecondChild content];
                                NSLog(@"liString:%@",liString);
                                NSDictionary *liAttributeDict = [liEle attributes];
                                NSLog(@"liAttributeDict:%@",liAttributeDict);
                                NSString *hrefStr = [NSString stringWithFormat:@"http://news.xiyou.edu.cn/xinwenwang/%@",[liAttributeDict objectForKey:@"href"]];
                                NSLog(@"hrefStr:%@",hrefStr);
                                
                                [bbsNewsArr addObject:liString];
                                [bbsHrefArr addObject:hrefStr];
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
                        
                        [bbsNewsArr addObject:liString];
                        [bbsHrefArr addObject:hrefStr];
                    }
                }
                
                
            }
            
            bbsNewsArray = [[NSArray alloc] initWithArray:bbsNewsArr];
            bbsHrefArray = [[NSArray alloc] initWithArray:bbsHrefArr];
            
        }
        
        [xpathParser release];
        xpathParser = nil;
    }
    
    [htmlData release];
    htmlData = nil;
    
    [bbsNewsTable reloadData];
    
    [SVProgressHUD dismiss];
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
    return [bbsNewsArray count];
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
    
    NSString *text = [bbsNewsArray objectAtIndex:[indexPath row]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    [cell.textLabel setText:text];
    [cell.textLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowNewsViewController *showNewsController = [[ShowNewsViewController alloc] initWithTag:viewTag];
    showNewsController.titleString = [[NSString stringWithFormat:@"%@",[bbsNewsArray objectAtIndex:indexPath.row]] copy];
    showNewsController.hrefString = [[NSString stringWithFormat:@"%@",[bbsHrefArray objectAtIndex:indexPath.row]] copy];
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
    NSString *text = [bbsNewsArray objectAtIndex:[indexPath row]];
    
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
