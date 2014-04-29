//
//  ImageAndTitle.m
//  LoveXiYou
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageAndTitle.h"

@implementation ImageAndTitle

@synthesize image = _image;
@synthesize title = _title;

-(void)dealloc{
    [_image release];
    _image = nil;
    [_title release];
    _title = nil;
    [super dealloc];
}

-(id)initWithImage:(NSString *)imageString andTitle:(NSString *)titleString{
    if (self = [super init]) {
        self.image = [[NSString alloc] initWithString:imageString];
        self.title = [[NSString alloc] initWithString:titleString];
    }
    return self;
}

@end
