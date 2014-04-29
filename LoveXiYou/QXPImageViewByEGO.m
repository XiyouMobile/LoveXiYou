//
//  QXPImageViewByEGO.m
//  V-Life
//
//  Created by allen apple on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QXPImageViewByEGO.h"
#import "EGOImageView.h"

@implementation QXPImageViewByEGO
@synthesize Qdelegate;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    if (Qdelegate&&[Qdelegate respondsToSelector:@selector(QXPImageView:)]) {
        [Qdelegate QXPImageView:self];
    }


}
-(void)dealloc{

    [super dealloc];

}
@end
