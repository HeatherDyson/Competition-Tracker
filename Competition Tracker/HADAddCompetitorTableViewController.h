//
//  HADAddCompetitorTableViewController.h
//  Competition Tracker
//
//  Created by Heather Dyson on 8/2/18.
//  Copyright © 2018 Heather Dyson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HADRankingsTableViewController.h"
#import "HADHourMinuteSecondPicker.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]


@interface HADAddCompetitorTableViewController : UITableViewController

@property (nonatomic, weak) HADRankingsTableViewController *rankingViewController;
@property NSMutableArray *fields;
@property NSMutableDictionary *fieldValDictionary; //dictionary of UITextField
@property NSMutableDictionary *thisCompetitor; //competitor to be edited if in editMode

- (IBAction)cancelButtonSelected:(id)sender;
- (IBAction)saveButtonSelected:(id)sender;


@end
