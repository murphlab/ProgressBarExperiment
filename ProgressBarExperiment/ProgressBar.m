//
//  ProgressBar.m
//  ProgressBarExperiment
//
//  Created by Ken Murphy on 6/14/16.
//  Copyright © 2016 Murphlab. All rights reserved.
//

#import "ProgressBar.h"

#define DEFAULT_BACKGROUND_BAR_COLOR colorWithWhite:1.0 alpha:0.25
#define DEFAULT_MAX_POSITION_BAR_COLOR colorWithWhite:1.0 alpha:0.5
#define DEFAULT_POSITION_BAR_COLOR colorWithWhite:1.0 alpha:1.0
#define DEFAULT_BUBBLE_WIDTH 30.0
#define DEFAULT_BUBBLE_FONT [UIFont systemFontOfSize:15.0]

@implementation ProgressBar

@synthesize backgroundBarColor = _backgroundBarColor;
@synthesize maxPositionBarColor = _maxPositionBarColor;
@synthesize positionBarColor = _positionBarColor;
@synthesize bubbleWidth = _bubbleWidth;
@synthesize bubbleFont = _bubbleFont;

- (void)setBackgroundBarColor:(UIColor *)backgroundBarColor
{
    if (![_backgroundBarColor isEqual:backgroundBarColor]) {
        _backgroundBarColor = backgroundBarColor;
        [self setNeedsDisplay];
    }
}

- (UIColor *)backgroundBarColor
{
    if (!_backgroundBarColor) {
        _backgroundBarColor = [UIColor DEFAULT_BACKGROUND_BAR_COLOR];
    }
    return _backgroundBarColor;
}

- (void)setMaxPositionBarColor:(UIColor *)maxPositionBarColor
{
    if (![_maxPositionBarColor isEqual:maxPositionBarColor]) {
        _maxPositionBarColor = maxPositionBarColor;
        [self setNeedsDisplay];
    }
}

- (UIColor *)maxPositionBarColor
{
    if (!_maxPositionBarColor) {
        _maxPositionBarColor = [UIColor DEFAULT_MAX_POSITION_BAR_COLOR];
    }
    return _maxPositionBarColor;
}

- (void)setPositionBarColor:(UIColor *)positionBarColor
{
    if (![_positionBarColor isEqual:positionBarColor]) {
        _positionBarColor = positionBarColor;
        [self setNeedsDisplay];
    }
}

- (UIColor *)positionBarColor
{
    if (!_positionBarColor) {
        _positionBarColor = [UIColor DEFAULT_POSITION_BAR_COLOR];
    }
    return _positionBarColor;
}

- (void)setBubbleWidth:(CGFloat)bubbleWidth
{
    if (_bubbleWidth != bubbleWidth) {
        _bubbleWidth = bubbleWidth;
        [self setNeedsDisplay];
    }
        
}

- (CGFloat)bubbleWidth
{
    if (_bubbleWidth == 0.0) { // _bubbleWidth == 0 = unset so use default
        _bubbleWidth = DEFAULT_BUBBLE_WIDTH;
    }
    return _bubbleWidth;
}

- (void)setBubbleFont:(UIFont *)bubbleFont
{
    if (![_bubbleFont isEqual:bubbleFont]) {
        _bubbleFont = bubbleFont;
        [self setNeedsDisplay];
    }
}

- (UIFont *)bubbleFont
{
    if (!_bubbleFont) {
        _bubbleFont = DEFAULT_BUBBLE_FONT;
    }
    return _bubbleFont;
}

- (void)setMaxPosition:(CGFloat)maxPosition
{
    if (_maxPosition != maxPosition) {
        _maxPosition = maxPosition;
        [self setNeedsDisplay];
    }
}

- (void)setPosition:(CGFloat)position
{
    if (_position != position) {
        _position = position;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {


    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawProgressBar:context];

}


-(void)drawProgressBar:(CGContextRef)context{
    
    // Calculate:
    // bar height based on view heigt. Same height for bar and bubble portion of position label.
    // Tick portion of position label and position label padding are percentage of height.
    // Some starting values:
    static CGFloat barHeightScale = 0.45;
    static CGFloat positionLabelBubbleHeightScale = 0.45;
    static CGFloat positionLabelTickHeightScale = 0.05;
    static CGFloat positionLabelVerticalPaddingScale = 0.05;
    
    CGContextSaveGState(context);
    UIGraphicsBeginImageContextWithOptions((self.frame.size), NO, 0.0);
    
    CGContextRef newContext = UIGraphicsGetCurrentContext();
    
    // Translate and scale image to compnesate for Quartz's inverted coordinate system
    CGContextTranslateCTM(newContext,0.0,self.frame.size.height);
    CGContextScaleCTM(newContext, 1.0, -1.0);
    
    
    //Draw mask
    CGFloat lineWidth = self.bounds.size.height * barHeightScale; // I know I know, line width is related to context height. It's confusing.
    CGFloat linePadX = lineWidth / 2.0; // Room for the endcaps.
    CGContextSetLineWidth(newContext, lineWidth);
    
    CGFloat barY = self.bounds.origin.y + self.bounds.size.height - lineWidth * 0.5; // pin to bottom of view
    CGFloat lineStartX = self.bounds.origin.x + linePadX;
    CGFloat lineEndX = self.bounds.origin.x + self.bounds.size.width - linePadX;
    CGContextMoveToPoint(newContext, lineStartX, barY);
    CGContextAddLineToPoint(newContext, lineEndX, barY);
    CGContextSetStrokeColorWithColor(newContext, [[UIColor blackColor] CGColor]);
    CGContextSetLineCap(newContext, kCGLineCapRound);
    CGContextStrokePath(newContext);
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    CGContextClipToMask(context, self.bounds, mask);
    
    // draw backgroundBar:
    
    CGContextSetFillColorWithColor(context, [self.backgroundBarColor CGColor]);
    CGContextFillRect(context, self.bounds);
    
    // draw maxPositionBar:
    
    CGRect maxPositionRect = CGRectMake(self.bounds.origin.x,
                                        self.bounds.origin.y,
                                        self.bounds.size.width * self.maxPosition,
                                        self.bounds.size.height);
    CGContextSetFillColorWithColor(context, [self.maxPositionBarColor CGColor]);
    CGContextFillRect(context, maxPositionRect);
    
    // draw positionBar:
    
    CGRect positionRect = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     self.bounds.size.width * self.position,
                                     self.bounds.size.height);
    CGContextSetFillColorWithColor(context, [self.positionBarColor CGColor]);
    CGContextFillRect(context, positionRect);
    
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
