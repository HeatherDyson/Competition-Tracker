//
//  HADRankingsTableViewController.h
//  Competition Tracker
//
//  Created by Heather Dyson on 8/2/18.
//  Copyright © 2018 Heather Dyson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HADCompTableViewController.h"
#import "ViewController.h"

@interface HADRankingsTableViewController : UITableViewController

@property (nonatomic, weak) HADCompTableViewController *competitionTableViewController;

- (void) addCompetitor: (NSMutableDictionary *) newCompetitor;
- (void) editCompetitor;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;

@property NSMutableDictionary *competitionDictionary;
@property NSMutableArray *competitorsArray;
@property NSArray *displayArray;
@property NSMutableArray *competitorFields;
@property NSInteger editIndex;
@property bool editMode;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end
