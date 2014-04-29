//
//  Database.m
//  LoveXiYou
//
//  Created by iphone2 on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Database.h"
#import <PlausibleDatabase/PlausibleDatabase.h>

static PLSqliteDatabase * dbPointer;


@implementation Database

//单例

+ (PLSqliteDatabase *) setup{
	if (dbPointer) {
		return dbPointer;
	}
	
	NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
	NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *realPath = [documentPath stringByAppendingPathComponent:@"Lessions.sqlite"];
	
	NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"Lessions" ofType:@"sqlite"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:realPath]) {
		NSError *error;
		if (![fileManager copyItemAtPath:sourcePath toPath:realPath error:&error]) {
			NSLog(@"%@",[error localizedDescription]);
		}
	}
	
	NSLog(@"复制sqlite到路径：%@成功。",realPath);
	
	//把dbpointer地址修改为可修改的realPath。
	dbPointer = [[PLSqliteDatabase alloc] initWithPath:realPath];
	
	[dbPointer open];
	
	return dbPointer;
}

+ (void) close{
	if (dbPointer) {
		[dbPointer close];
		dbPointer = NULL;
	}
}

- (void)dealloc{
    [dbPointer close];
    dbPointer = NULL;
    [super dealloc];
}

@end

