//
//  LoveXiYouAppDelegate.m
//  LoveXiYou
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoveXiYouAppDelegate.h"

/*
@interface LoveXiYouAppDelegate ()
- (void)updateMethod:(NSDictionary *)appInfo;

@end
 */

@implementation LoveXiYouAppDelegate

@synthesize window = _window;
@synthesize myTabBarVC;

- (void)dealloc
{
    [_window release];
    [tabBarController release];
    [newsNav release];
    [groupNav release];
    [courseNav release];
    [moreNav release];  
    [myTabBarVC release];
    [super dealloc];
}

- (void)umengTrack {
    
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    
}

//获取uuid
-(NSString*) uuid {  
    CFUUIDRef puuid = CFUUIDCreate( nil );  
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );  
    NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);  
    CFRelease(puuid);  
    CFRelease(uuidString);  
    return [result autorelease];  
} 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"uuid:%@",[self uuid]);
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    [MobClick event:@"test" label:@"test" acc:1];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.myTabBarVC = [[LoveXiYouViewController alloc] init];
    self.window.rootViewController = self.myTabBarVC;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
 - (void)updateMethod:(NSDictionary *)appInfo {
    NSLog(@"update info %@",appInfo);
}
*/

@end
