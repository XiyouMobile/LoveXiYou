//
//  CloNetworkUtil.h
//  LoveXiYou
//
//  Created by Pro on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface CloNetworkUtil : NSObject {
    
}

+ (Reachability *)initReachability; 
+ (BOOL)getNetWorkStatus; 
+ (NSString *)getNetWorkType; 

@end
