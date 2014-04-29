//
//  CloNetworkUtil.m
//  LoveXiYou
//
//  Created by Pro on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CloNetworkUtil.h"

@implementation CloNetworkUtil

- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}

//初始化reachability 
+ (Reachability *)initReachability{ 
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"]; 
    return reachability; 
} 

//判断网络是否可用 
+ (BOOL)getNetWorkStatus{ 
    if ([[self initReachability] currentReachabilityStatus] == NotReachable) { 
        return NO; 
    }else { 
        return YES; 
    } 
} 

/**
 获取网络类型
 return
 */ 
+ (NSString *)getNetWorkType 
{ 
    NSString *netWorkType; 
    Reachability *reachability = [self initReachability]; 
    switch ([reachability currentReachabilityStatus]) { 
        case ReachableViaWiFi:   //Wifi网络 
            netWorkType = @"wifi"; 
            break; 
        case ReachableViaWWAN:  //无线广域网 
            netWorkType = @"wwan";  
            break; 
        default: 
            netWorkType = @"no"; 
            break; 
    } 
    return netWorkType; 
} 

- (void)dealloc{
    [super dealloc];
}

@end
