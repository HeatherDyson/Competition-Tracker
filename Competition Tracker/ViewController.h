//
//  ViewController.h
//  Competition Tracker
//
//  Created by Heather Dyson on 7/25/18.
//  Copyright © 2018 Heather Dyson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *competitorInfo;
@property (nonatomic, strong) NSString *infoText;
@property NSInteger infoLines;

@end

