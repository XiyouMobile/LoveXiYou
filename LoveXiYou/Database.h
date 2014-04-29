//
//  Database.h
//  LoveXiYou
//
//  Created by iphone2 on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PlausibleDatabase/PlausibleDatabase.h>

@interface Database : NSObject {
    
}

+ (PLSqliteDatabase *) setup;

+ (void) close;

@end
