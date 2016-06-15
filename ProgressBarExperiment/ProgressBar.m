//
//  ProgressBar.m
//  ProgressBarExperiment
//
//  Created by Ken Murphy on 6/14/16.
//  Copyright © 2016 Murphlab. All rights reserved.
//

#import "ProgressBar.h"

@implementation ProgressBar


- (void)drawRect:(CGRect)rect {
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 20.0);
    CGFloat middleY = self.bounds.origin.y + self.bounds.size.height / 2.0;
    static CGFloat linePadX = 20.0;
    CGFloat lineStartX = self.bounds.origin.x + linePadX;
    CGFloat lineEndX = self.bounds.origin.x + self.bounds.size.width - linePadX;
    CGContextMoveToPoint(context, lineStartX, middleY);
    CGContextAddLineToPoint(context, lineEndX, middleY);
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawProgressBar:context];

}


-(void)drawProgressBar:(CGContextRef)context{
    
    CGContextSaveGState(context);
        UIGraphicsBeginImageContextWithOptions((self.frame.size), NO, 0.0);
    
    CGContextRef newContext = UIGraphicsGetCurrentContext();
    
    // Translate and scale image to compnesate for Quartz's inverted coordinate system
    CGContextTranslateCTM(newContext,0.0,self.frame.size.height);
    CGContextScaleCTM(newContext, 1.0, -1.0);
    
    
    //Draw mask
    CGFloat lineWidth = 20.0;
    CGFloat linePadX = lineWidth / 2.0;
    CGContextSetLineWidth(newContext, lineWidth);
    CGFloat middleY = self.bounds.origin.y + self.bounds.size.height / 2.0;
    CGFloat lineStartX = self.bounds.origin.x + linePadX;
    CGFloat lineEndX = self.bounds.origin.x + self.bounds.size.width - linePadX;
    CGContextMoveToPoint(newContext, lineStartX, middleY);
    CGContextAddLineToPoint(newContext, lineEndX, middleY);
    CGContextSetStrokeColorWithColor(newContext, [[UIColor blackColor] CGColor]);
    CGContextSetLineCap(newContext, kCGLineCapRound);
    CGContextStrokePath(newContext);
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    CGContextClipToMask(context, self.bounds, mask);
    
    // draw bar

    
    CGRect progressRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width / 2.0, self.bounds.size.height);
    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextFillRect(context, progressRect);
    
    
    CGImageRelease(mask);
    CGContextRestoreGState(context);
    
    
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint locationInView = [touch locationInView:self];
    NSLog(@"beginTracking: %g %g", locationInView.x, locationInView.y);
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint locationInView = [touch locationInView:self];
    NSLog(@"continueTracking: %g %g", locationInView.x, locationInView.y);
    return YES;
}

@end
