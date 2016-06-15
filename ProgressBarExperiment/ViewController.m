//
//  ViewController.m
//  ProgressBarExperiment
//
//  Created by Ken Murphy on 6/14/16.
//  Copyright © 2016 Murphlab. All rights reserved.
//

#import "ViewController.h"
#import "ProgressBar.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet ProgressBar *progressBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    self.progressBar.maxPosition = 0.66;
    self.progressBar.position = 0.33;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
