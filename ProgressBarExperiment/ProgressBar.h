//
//  ProgressBar.h
//  ProgressBarExperiment
//
//  Created by Ken Murphy on 6/14/16.
//  Copyright © 2016 Murphlab. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Custom UIControl that presents an interactive progress bar.
 Modeled roughly after scrubbable video player control.
 When the user updates the position by scrubbing the bar,
 a UIControlEventValueChanged is sent. The permissable range
 of the position property (analogous to current position in video)
 is determined by the maxPosition property (analogous to how much
 video is available).
 */
@interface ProgressBar : UIControl

/** Background color of entire progress bar.
 Has a reasonable default (see implementation).
 */
@property (nonatomic, strong) UIColor *backgroundBarColor;

/** Color of bar indicating maximum position that position bar can be set to.
 Has a reasonable default (see implementation).
 */
@property (nonatomic, strong) UIColor *maxPositionBarColor;

/** Color of interactive bar indicating current position.
 Has a reasonable default (see implementation).
 */
@property (nonatomic, strong) UIColor *positionBarColor;

/** Color of pointer (bubble + tick)
 Has a reasonable default (see implementation).
 */
@property (nonatomic, strong) UIColor *pointerColor;

/** Horizontal length of bubble.
 Has a reasonable default (see implementation).
 */
@property (nonatomic) CGFloat bubbleLength;

/** UILabel displayed inside the pointer bubble.
 It is the responsibility of the client to update the text (e.g. when the valueChanged action is sent).
 You probably will want to modify its properties to configure its appearance.
 */
@property (readonly, weak) UILabel *bubbleLabel;

/** Max value position can be set to. Range is from 0.0 to 1.0.
 Setting this updates the max position bar, and limits how far the interactive
 postion bar can be "scrubbed." Setting this below the current position value
 updates the position value and bar position, but does NOT result in a 
 UIControlEventValueChanged. If the client changes this, it's their responsibility 
 to sync to the updated value of position.
 */
@property (nonatomic) CGFloat maxPosition;

/** Value of the current position. Range is from 0.0 to 1.0.
 Setting this updates the position bar. It is clamped between 0.0 and maxPosition.
 It is updated when the user "scrubs" the position bar within the allowed range.
 */
@property (nonatomic) CGFloat position;

@end
