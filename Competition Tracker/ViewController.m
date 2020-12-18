//
//  ViewController.m
//  Competition Tracker
//
//  Created by Heather Dyson on 7/25/18.
//  Copyright © 2018 Heather Dyson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize competitorInfo;
@synthesize infoText;
@synthesize infoLines;

- (void)viewDidLoad {
    [super viewDidLoad];
    [competitorInfo setNumberOfLines:infoLines];
    [competitorInfo setText:infoText];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
