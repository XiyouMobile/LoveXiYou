//
//  QXPImageViewByEGO.h
//  V-Life
//
//  Created by allen apple on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@class QXPImageViewByEGO;

@protocol QXPImageViewDelegate <NSObject>

@optional
-(void)QXPImageView:(QXPImageViewByEGO *)imageView;

@end
@interface QXPImageViewByEGO : EGOImageView{

    id<QXPImageViewDelegate>Qdelegate;

}
@property(nonatomic,assign)id<QXPImageViewDelegate>Qdelegate;
@end
