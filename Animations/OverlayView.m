//
//  OverlayView.m
//  Animations
//
//  Created by Oleg Trakhman on 1/10/14.
//  Copyright (c) 2014 animations. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView

- (void)drawRect:(CGRect)rect
{
    const CGFloat kCircleWidth = 120.0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetGrayStrokeColor(context, 0.3, 1.0);
	CGContextSetLineWidth(context, kCircleWidth);
    CGContextAddArc(context, self.rotationCenter.x, self.rotationCenter.y, self.radius, 0.0, M_PI_2, true);
	CGContextStrokePath(context);
    
}

@end
