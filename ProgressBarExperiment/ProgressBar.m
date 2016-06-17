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
#define DEFAULT_POINTER_COLOR DEFAULT_POSITION_BAR_COLOR
#define DEFAULT_BUBBLE_LENGTH 56.0

static const CGFloat kBarHeightScale = 0.42;
static const CGFloat kPositionLabelBubbleHeightScale = 0.42;
static const CGFloat kPositionLabelTickHeightScale = 0.11;
static const CGFloat kTickffsetXFactor = 0.8; // (ratio of 1 side of triangle to height) / 2 [for equilateral triangle: 0.577]


@interface ProgressBar ()
@property (nonatomic, readonly) CGRect progressBarRect;
@end

@implementation ProgressBar

@synthesize backgroundBarColor = _backgroundBarColor;
@synthesize maxPositionBarColor = _maxPositionBarColor;
@synthesize positionBarColor = _positionBarColor;
@synthesize pointerColor = _pointerColor;
@synthesize bubbleLength = _bubbleLength;
@synthesize bubbleLabel = _bubbleLabel;

#pragma mark - Getters and Setters

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

- (void)setBubbleLength:(CGFloat)bubbleLength
{
    if (_bubbleLength != bubbleLength) {
        _bubbleLength = bubbleLength;
        [self setNeedsDisplay];
    }
        
}

- (void)setPointerColor:(UIColor *)pointerColor
{
    if (![_pointerColor isEqual:pointerColor]) {
        _pointerColor = pointerColor;
        [self setNeedsDisplay];
    }
}

- (UIColor *)pointerColor
{
    if (!_pointerColor) {
        _pointerColor = [UIColor DEFAULT_POINTER_COLOR];
    }
    return _pointerColor;
}

- (CGFloat)bubbleLength
{
    if (_bubbleLength == 0.0) { // _bubbleLength == 0 = unset so use default
        _bubbleLength = DEFAULT_BUBBLE_LENGTH;
    }
    return _bubbleLength;
}

// TODO: HOW TO HANDLE POLICING RELATIVE MAXPOSTION/POSITION VALUES?
// Can prevent position from being set greater than maxPosition.
// But what if maxPosition is changed to a value lower than current position?
// Adjust position? Would we then send out an action that the position value has changed?

- (void)setMaxPosition:(CGFloat)maxPosition
{
    if (_maxPosition != maxPosition) {
        _maxPosition = maxPosition;
        [self setNeedsDisplay];
    }
}

- (void)setPosition:(CGFloat)position
{
    position = MIN(self.maxPosition, position);
    position = MAX(0.0, position);
    if (_position != position) {
        _position = position;
        [self setNeedsDisplay];
    }
}

- (CGRect)progressBarRect
{
    CGFloat barHeight = self.bounds.size.height * kBarHeightScale;
    return CGRectMake(self.bounds.origin.x + self.bubbleLength / 2.0,
                      self.bounds.origin.y + self.bounds.size.height - barHeight,
                      self.bounds.size.width - self.bubbleLength,
                      barHeight);
}

- (UILabel *)bubbleLabel
{
    if (!_bubbleLabel) {
        UILabel *bubbleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bubbleLabel = bubbleLabel;
        _bubbleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_bubbleLabel];
        return _bubbleLabel;
    } else {
        return _bubbleLabel;
    }
}

#pragma mark - UIView

// Handle rotation or other geometry change:
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
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

    
    CGContextSaveGState(context);
    UIGraphicsBeginImageContextWithOptions((self.frame.size), NO, 0.0);
    
    CGContextRef newContext = UIGraphicsGetCurrentContext();
    
    // Translate and scale image to compnesate for Quartz's inverted coordinate system
    CGContextTranslateCTM(newContext,0.0,self.frame.size.height);
    CGContextScaleCTM(newContext, 1.0, -1.0);
    
    CGFloat barPadding = self.bubbleLength / 2.0;
    
    //Draw mask
    CGFloat lineWidth = self.bounds.size.height * kBarHeightScale; // I know I know, line width is related to context height. It's confusing.
    CGFloat linePadX = lineWidth / 2.0 + barPadding; // Room for the endcaps + padding for bubble room when at edges.
    CGContextSetLineWidth(newContext, lineWidth);

    
    CGFloat barY = self.bounds.origin.y + self.bounds.size.height - lineWidth * 0.5; // pin to bottom of view
    CGFloat lineStartX = self.bounds.origin.x + linePadX;
    CGFloat lineEndX = self.bounds.origin.x + self.bounds.size.width - linePadX;
    CGContextMoveToPoint(newContext, lineStartX, barY);
    CGContextAddLineToPoint(newContext, lineEndX, barY);
    CGContextSetStrokeColorWithColor(newContext, [[UIColor blackColor] CGColor]);
    CGContextSetLineCap(newContext, kCGLineCapRound);
    CGContextStrokePath(newContext);
    
    // Need to calculate these early to calculate upperMaskHeight:
    CGFloat bubbleLineWidth = self.bounds.size.height * kPositionLabelBubbleHeightScale;
    CGFloat tickHeight = kPositionLabelTickHeightScale * self.bounds.size.height;
    CGFloat upperMaskRectHeight = bubbleLineWidth + tickHeight;
    
    // Upper mask allows visiblility of position bubble+tick:
    CGRect upperMaskRect = CGRectMake(self.bounds.origin.x,
                                      self.bounds.origin.y,
                                      self.bounds.size.width,
                                      upperMaskRectHeight);
    CGContextFillRect(newContext, upperMaskRect);
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    CGContextClipToMask(context, self.bounds, mask);
    
    // draw backgroundBar:
    
    CGContextSetFillColorWithColor(context, [self.backgroundBarColor CGColor]);
    CGContextFillRect(context, self.progressBarRect);
    
    // draw maxPositionBar:
    
    CGRect maxPositionRect = CGRectMake(self.progressBarRect.origin.x,
                                        self.progressBarRect.origin.y,
                                        self.progressBarRect.size.width * self.maxPosition,
                                        self.progressBarRect.size.height);
    CGContextSetFillColorWithColor(context, [self.maxPositionBarColor CGColor]);
    CGContextFillRect(context, maxPositionRect);
    
    // draw positionBar:
    
    CGRect positionRect = CGRectMake(self.progressBarRect.origin.x,
                                     self.progressBarRect.origin.y,
                                     self.progressBarRect.size.width * self.position,
                                     self.progressBarRect.size.height);
    CGContextSetFillColorWithColor(context, [self.positionBarColor CGColor]);
    CGContextFillRect(context, positionRect);
    
    // draw bubble:
    CGFloat bubbleLineLength = self.bubbleLength - bubbleLineWidth; // subtracting the length added by endcaps, which combined = bubbleLineWidth
    if (bubbleLineLength <= 0) NSLog(@"WARNING! BUBBLE LENGHT SHOULD BE GREATER");
    bubbleLineLength = MAX(0, bubbleLineLength); // make sure it's at least zero: with endcaps it will be a circle.
    CGFloat bubbleY = self.bounds.origin.y + bubbleLineWidth / 2.0;
    CGFloat bubbleCenterX = (self.bounds.origin.x + barPadding) + self.progressBarRect.size.width * self.position;
    CGFloat bubbleLineStartX = bubbleCenterX - bubbleLineLength / 2.0;
    CGFloat bubbleLineEndX = bubbleCenterX + bubbleLineLength / 2.0;

    CGContextSetLineWidth(context, bubbleLineWidth);
    CGContextMoveToPoint(context, bubbleLineStartX, bubbleY);
    CGContextAddLineToPoint(context, bubbleLineEndX, bubbleY);
    CGContextSetStrokeColorWithColor(context, [self.pointerColor CGColor]);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);

    // draw tick
    CGFloat offsetX = kTickffsetXFactor * tickHeight;
    CGFloat tickTopY = bubbleY + bubbleLineWidth / 2.0 - 1.0; // -1 to create a wee bit of overlap
    CGPoint tickVertexA = CGPointMake(bubbleCenterX - offsetX, tickTopY);
    CGPoint tickVertexB = CGPointMake(bubbleCenterX + offsetX, tickTopY);
    CGPoint tickVertexC = CGPointMake(bubbleCenterX, tickTopY + tickHeight);
    CGContextMoveToPoint(context, tickVertexA.x, tickVertexA.y);
    CGContextAddLineToPoint(context, tickVertexB.x, tickVertexB.y);
    CGContextAddLineToPoint(context, tickVertexC.x, tickVertexC.y);
    CGContextAddLineToPoint(context, tickVertexA.x, tickVertexA.y);
    CGContextSetFillColorWithColor(context, [self.pointerColor CGColor]);
    CGContextFillPath(context);
    
    CGImageRelease(mask);
    CGContextRestoreGState(context);
    
    [self updateBubbleLabelWithWidth:self.bubbleLength height:bubbleLineWidth * 0.8 center:CGPointMake(bubbleCenterX, bubbleY)];
}

- (void)updateBubbleLabelWithWidth:(CGFloat)width height:(CGFloat)height center:(CGPoint)center
{
    self.bubbleLabel.frame = CGRectMake(0, 0, width, height);
    self.bubbleLabel.center = center;
}

#pragma mark - UIControl

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint locationInView = [touch locationInView:self];
    if (CGRectContainsPoint(self.progressBarRect, locationInView)) {
        [self setPositionWithLocationInViewX:locationInView.x];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint locationInView = [touch locationInView:self];
    [self setPositionWithLocationInViewX:locationInView.x];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

- (void)setPositionWithLocationInViewX:(CGFloat)x
{
    self.position = (x - self.bounds.origin.x - self.bubbleLength / 2.0) / self.progressBarRect.size.width;
}


@end
