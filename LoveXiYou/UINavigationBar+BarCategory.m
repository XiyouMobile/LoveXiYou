//
//  UINavigationBar+BarCategory.m
//  VLive2
//
//  Created by allenapple on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBar+BarCategory.h"

@implementation UINavigationBar (BarCategory)
- (void)drawRect:(CGRect)rect {  
     UIImage *bigBackImage=[UIImage imageNamed:@"shangdaohtao.png"];
    UIImage *image = bigBackImage;  //背景图片
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)]; 
    self.tintColor=[UIColor clearColor];
} 
@end
