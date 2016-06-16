//
//  ViewController.m
//  ProgressBarExperiment
//
//  Created by Ken Murphy on 6/14/16.
//  Copyright © 2016 Murphlab. All rights reserved.
//

#import "ViewController.h"
#import "ProgressBar.h"

static const int numDays = 29;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet ProgressBar *progressBar;

@property (weak, nonatomic) IBOutlet UIStepper *maxStepper;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UIStepper *currentStepper;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressBar.maxPosition = 15.0 / numDays;
    [self updateBubbleLabel];
    [self updateSteppersFromProgressBar];
}

- (IBAction)progressSliderChanged:(id)sender {
    NSLog(@"POSITION: %g", self.progressBar.position);
    [self updateBubbleLabel];
    [self updateSteppersFromProgressBar];
}

- (IBAction)stepperTapped:(id)sender {
    [self updateStepperLabels];
    [self updateProgressBar];
    [self updateBubbleLabel];
}

- (void)updateSteppersFromProgressBar
{
    self.maxStepper.value = (int)(self.progressBar.maxPosition * numDays);
    self.currentStepper.value = (int)(self.progressBar.position * numDays);
    [self updateStepperLabels];
}

- (void)updateStepperLabels
{
    self.maxLabel.text = [NSString stringWithFormat:@"%d", (int)self.maxStepper.value];
    self.currentLabel.text = [NSString stringWithFormat:@"%d", (int)self.currentStepper.value];
}
- (void)updateBubbleLabel
{
    int day = numDays * self.progressBar.position;
    self.progressBar.bubbleLabel.text = [NSString stringWithFormat:@"Day %d", day];
    NSLog(@"LABEL: %@", self.progressBar.bubbleLabel.text);
}

- (void)updateProgressBar
{
    self.progressBar.maxPosition = (CGFloat)self.maxStepper.value / (CGFloat)numDays;
    self.progressBar.position = (CGFloat)self.currentStepper.value / (CGFloat)numDays;
}

@end
