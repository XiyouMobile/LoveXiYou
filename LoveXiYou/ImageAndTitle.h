//
//  ImageAndTitle.h
//  LoveXiYou
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageAndTitle : NSObject {
    NSString *_image;
    NSString *_title;
}

@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *title;

//初始化图片名称和九宫格中每个logo下方题标
-(id)initWithImage:(NSString *)imageString andTitle:(NSString *)titleString;

@end
