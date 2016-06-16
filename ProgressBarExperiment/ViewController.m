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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.progressBar.maxPosition = 1.0;
    self.progressBar.position = 0.33;
    [self updateBubbleLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)progressSliderChanged:(id)sender {
    NSLog(@"POSITION: %g", self.progressBar.position);
    [self updateBubbleLabel];
}

- (void)updateBubbleLabel
{
    int day = numDays * self.progressBar.position;
    self.progressBar.bubbleLabel.text = [NSString stringWithFormat:@"Day %d", day];
    NSLog(@"LABEL: %@", self.progressBar.bubbleLabel.text);
}

@end
