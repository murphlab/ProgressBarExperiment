//
//  ProgressBar.h
//  ProgressBarExperiment
//
//  Created by Ken Murphy on 6/14/16.
//  Copyright © 2016 Murphlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBar : UIControl

@property (nonatomic, strong) UIColor *backgroundBarColor;
@property (nonatomic, strong) UIColor *maxPositionBarColor;
@property (nonatomic, strong) UIColor *positionBarColor;

@property (nonatomic) CGFloat bubbleLength;
@property (nonatomic, strong) UIFont *bubbleFont;

@property (nonatomic) CGFloat maxPosition;
@property (nonatomic) CGFloat position;

@end
