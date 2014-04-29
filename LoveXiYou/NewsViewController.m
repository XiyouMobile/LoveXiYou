//
//  NewsViewController.m
//  LoveXiYou
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsViewController.h"
#import "BookViewController.h"
#import "CourseViewController.h"
#import "AboutViewController.h"
#import "ListViewController.h"
#import "CurrentNewsViewController.h"
#import "DetailBlogViewController.h"
#import "CloNetworkUtil.h"

@implementation NewsViewController

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

-(void)dealloc{
    [logoTableView_ release];
    logoTableView_ = nil;
    if (logoViewCell_ != nil) {
        [logoViewCell_ release];
        logoViewCell_ = nil;
    }
    if (logoCrossViewCell_ != nil) {
        [logoCrossViewCell_ release];
        logoCrossViewCell_ = nil;
    }
    
    [itemArray release];
    itemArray = nil;
    [imageArray release];
    imageArray = nil;
    [titleArray release];
    titleArray = nil;
    [super dealloc];
}

#pragma mark - AppDelegate methods

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    //[MobClick beginLogPageView:@"OnePage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[MobClick endLogPageView:@"OnePage"];
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
    
    //创建
    itemArray = [[NSMutableArray alloc] init];
    NSArray *itemArr = [NSArray arrayWithObjects:
                        [[[ImageAndTitle alloc] initWithImage:@"邮电绿色_西邮简介" andTitle:@"西邮简介"] autorelease],
                        [[[ImageAndTitle alloc] initWithImage:@"邮电绿色_院系介绍" andTitle:@"院系介绍"] autorelease],
						[[[ImageAndTitle alloc] initWithImage:@"邮电绿色_西邮图书" andTitle:@"西邮图书"] autorelease],
						[[[ImageAndTitle alloc] initWithImage:@"邮电绿色_西邮实事" andTitle:@"西邮实事"] autorelease],
                        [[[ImageAndTitle alloc] initWithImage:@"邮电绿色_西邮BBS" andTitle:@"西邮bbs"] autorelease],
                        [[[ImageAndTitle alloc] initWithImage:@"邮电绿色_失物招领" andTitle:@"失物招领"] autorelease],
                        [[[ImageAndTitle alloc] initWithImage:@"邮电绿色_MobileClub" andTitle:@"MobileClub"] autorelease],
                        //[[[ImageAndTitle alloc] initWithImage:@"序号6.png" andTitle:@"学术公告"] autorelease],
                       // [[[ImageAndTitle alloc] initWithImage:@"序号7.png" andTitle:@"西邮新闻"] autorelease],
                        nil];
    [self setItem:itemArr];
    
    logoTableView_ = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    logoTableView_.delegate = self;
    logoTableView_.dataSource = self;
    logoTableView_.separatorColor = [UIColor clearColor]; 
    [self.view addSubview:logoTableView_];
}

//设定itemArray
- (void)setItem:(NSArray *)temperatureArray{
    [itemArray addObjectsFromArray:temperatureArray];
}

//为itemArray中添加对象
- (void)addItem:(ImageAndTitle *)iat{
    [itemArray addObject:iat];
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
    logoTableView_.frame = self.view.bounds;
    [logoTableView_ reloadData];
    return YES;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 122;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int arrCount = [itemArray count] / 3;
    arrLeave = [itemArray count] % 3;
    if (arrLeave != 0) {
        arrCount++;
    }
    NSLog(@"arrCount:%d",arrCount);
    return arrCount;
}

#pragma mark setCellType
//设定tableView中cell中的内容，竖屏时
- (UITableViewCell *)setCellItem:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ViewCell";
	LogoViewCell *cell = (LogoViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        logoViewCell_ = [[[LogoViewCell alloc] init] autorelease];
        logoViewCell_.delegate = self;
        cell = logoViewCell_;
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    if ((indexPath.row * 3) <= ([itemArray count] - 1)) {
        ImageAndTitle * imgAndTitle = [itemArray objectAtIndex:indexPath.row * 3];
        cell.leftLabel.text = [NSString stringWithFormat:@"%@",imgAndTitle.title];
        [cell.leftBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgAndTitle.image]] forState:UIControlStateNormal];
        [cell.leftBtn setTag:indexPath.row * 3];
        
        if ((indexPath.row * 3 / 3 == [itemArray count] / 3) && ((indexPath.row * 3) % 3 > arrLeave - 1)) {
            cell.leftBtn.hidden = YES;
            [cell.leftBtn removeFromSuperview];
            cell.leftLabel.hidden = YES;
            [cell.leftLabel removeFromSuperview];
        }
        
        if ((indexPath.row * 3 / 3 == [itemArray count] / 3) && ((indexPath.row * 3 + 1) % 3 > arrLeave - 1)) {
            cell.middleBtn.hidden = YES;
            [cell.middleBtn removeFromSuperview];
            cell.middleLabel.hidden = YES;
            [cell.middleLabel removeFromSuperview];
        }
        
        if ((indexPath.row * 3 / 3 == [itemArray count] / 3) && ((indexPath.row * 3 + 2) % 3 > arrLeave - 1)) {
            cell.rightBtn.hidden = YES;
            [cell.rightBtn removeFromSuperview];
            cell.rightLabel.hidden = YES;
            [cell.rightLabel removeFromSuperview];
        }
        
    }
    if ((indexPath.row * 3 + 1) <= ([itemArray count] - 1)) {
		ImageAndTitle *imgAndTitle=[itemArray objectAtIndex:indexPath.row * 3 + 1];
		cell.middleLabel.text=[NSString stringWithFormat:@"%@",imgAndTitle.title];
		[cell.middleBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgAndTitle.image]] forState:UIControlStateNormal];
		[cell.middleBtn setTag:indexPath.row * 3+1];
        
        
	}
	if ((indexPath.row * 3 + 2) <= ([itemArray count] - 1)) {
		ImageAndTitle * imgAndTitle=[itemArray objectAtIndex:indexPath.row * 3 + 2];
		cell.rightLabel.text=[NSString stringWithFormat:@"%@",imgAndTitle.title];
		[cell.rightBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgAndTitle.image]] forState:UIControlStateNormal];
		[cell.rightBtn setTag:indexPath.row * 3 + 2];
        
	}
    
    return cell;
}

//设定tableView中cell中的内容,横屏时
- (UITableViewCell *)setCellItem:(UITableView *)tableView cellForRowAtIndexPathCross:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ViewCell";
	LogoCrossViewCell *cell = (LogoCrossViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        logoCrossViewCell_ = [[[LogoCrossViewCell alloc] init] autorelease];
        logoCrossViewCell_.delegate = self;
        cell = logoCrossViewCell_;
    }
    if ((indexPath.row * 3) <= ([itemArray count] - 1)) {
        ImageAndTitle * imgAndTitle = [itemArray objectAtIndex:indexPath.row * 3];
        cell.leftCrossLabel.text = [NSString stringWithFormat:@"%@",imgAndTitle.title];
        [cell.leftCrossBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgAndTitle.image]] forState:UIControlStateNormal];
        [cell.leftCrossBtn setTag:indexPath.row * 3];
        
        if ((indexPath.row * 3 / 3 == [itemArray count] / 3) && ((indexPath.row * 3) % 3 > arrLeave - 1)) {
            cell.leftCrossBtn.hidden = YES;
            [cell.leftCrossBtn removeFromSuperview];
            cell.leftCrossLabel.hidden = YES;
            [cell.leftCrossLabel removeFromSuperview];
        }
        
        if ((indexPath.row * 3 / 3 == [itemArray count] / 3) && ((indexPath.row * 3 + 1) % 3 > arrLeave - 1)) {
            cell.middleCrossBtn.hidden = YES;
            [cell.middleCrossBtn removeFromSuperview];
            cell.middleCrossLabel.hidden = YES;
            [cell.middleCrossLabel removeFromSuperview];
        }
        
        if ((indexPath.row * 3 / 3 == [itemArray count] / 3) && ((indexPath.row * 3 + 2) % 3 > arrLeave - 1)) {
            cell.rightCrossBtn.hidden = YES;
            [cell.rightCrossBtn removeFromSuperview];
            cell.rightCrossLabel.hidden = YES;
            [cell.rightCrossLabel removeFromSuperview];
        }
    }
    if ((indexPath.row * 3 + 1) <= ([itemArray count] - 1)) {
		ImageAndTitle *imgAndTitle=[itemArray objectAtIndex:indexPath.row * 3 + 1];
		cell.middleCrossLabel.text=[NSString stringWithFormat:@"%@",imgAndTitle.title];
		[cell.middleCrossBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgAndTitle.image]] forState:UIControlStateNormal];
		[cell.middleCrossBtn setTag:indexPath.row * 3+1];
	}
	if ((indexPath.row * 3 + 2) <= ([itemArray count] - 1)) {
		ImageAndTitle * imgAndTitle=[itemArray objectAtIndex:indexPath.row * 3 + 2];
		cell.rightCrossLabel.text=[NSString stringWithFormat:@"%@",imgAndTitle.title];
		[cell.rightCrossBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgAndTitle.image]] forState:UIControlStateNormal];
		[cell.rightCrossBtn setTag:indexPath.row * 3 + 2];
	}
    
    return cell;
}

- (void)onCellItem:(int)index{
    
    switch (index) {
        case 0:
            [MobClick event:@"西邮简介"];
            NSLog(@"西邮简介");
            ListViewController *introductionListController = [[ListViewController alloc] initWithViewTag:101];
            [self.navigationController pushViewController:introductionListController animated:YES];
            [introductionListController release];
            break;
        case 1:
            NSLog(@"院系介绍");
            [MobClick event:@"院系介绍"];
            ListViewController *partController = [[ListViewController alloc] initWithViewTag:102];
            [self.navigationController pushViewController:partController animated:YES];
            [partController release];
            break;
        case 2:
            NSLog(@"西邮图书");
            [MobClick event:@"西邮图书"];
            BookViewController *bookController = [[BookViewController alloc] init];
            [self.navigationController pushViewController:bookController animated:YES];
            [bookController release];
            break;
        case 3:
            NSLog(@"西邮实事");
            [MobClick event:@"西邮实事"];
            if (![CloNetworkUtil getNetWorkStatus]) {
                [ModalAlert say:@"未连接网络\n请稍检查您的网络设置..."];
            }else {
                CurrentNewsViewController *xiyouAnnouncementController = [[CurrentNewsViewController alloc] init];
                xiyouAnnouncementController.title = @"西邮公告";
                [self.navigationController pushViewController:xiyouAnnouncementController animated:YES];
                [xiyouAnnouncementController release];
            }
            break;
        case 4:
            NSLog(@"西邮bbs");
            [MobClick event:@"西邮bbs"];
            if (![CloNetworkUtil getNetWorkStatus]) {
                [ModalAlert say:@"未连接网络\n请稍检查您的网络设置..."];
            }else {
                DetailBlogViewController *bbsController = [[DetailBlogViewController alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
                bbsController.title = [NSString stringWithFormat:@"西邮BBS"];
                [self.navigationController pushViewController:bbsController animated:YES];
                [bbsController release];
            }
            break;
        case 5:
            NSLog(@"失物招领");
            [MobClick event:@"失物招领"];
            if (![CloNetworkUtil getNetWorkStatus]) {
                [ModalAlert say:@"未连接网络\n请稍检查您的网络设置..."];
            }else {
                DetailBlogViewController *detailViewLast = [[DetailBlogViewController alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
                detailViewLast.title = [NSString stringWithFormat:@"西邮失物招领"];
                [self.navigationController pushViewController:detailViewLast animated:YES];
                [detailViewLast release];
            }
            break;
        case 6:
            NSLog(@"MobileClub");
            [MobClick event:@"MobileClub"];
            AboutViewController *aboutController = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:aboutController animated:YES];
            [aboutController release];
            break;
        default:
            break;
    }
}

//初始化tableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1和2设定横屏，3和4设定竖屏
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case 1:
            return [self setCellItem:tableView cellForRowAtIndexPath:indexPath];
            break;
        case 2:
            return [self setCellItem:tableView cellForRowAtIndexPath:indexPath];
            break;
        case 3:
            return [self setCellItem:tableView cellForRowAtIndexPathCross:indexPath];
            break;
        case 4:
            return [self setCellItem:tableView cellForRowAtIndexPathCross:indexPath];
            break;
        default:
            break;
    }
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
