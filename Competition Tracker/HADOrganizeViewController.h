//
//  HADOrganizeViewController.h
//  Competition Tracker
//
//  Created by Heather Dyson on 8/4/18.
//  Copyright © 2018 Heather Dyson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HADRankingsTableViewController.h"

@interface HADOrganizeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (IBAction)sortButtonPressed:(id)sender;
- (IBAction)removeSortFieldButtonPressed:(id)sender;
- (IBAction)clearSortButtonPressed:(id)sender;


@property (nonatomic, weak) HADRankingsTableViewController *rankingTVC;
@property (nonatomic, strong) NSMutableArray *fieldArray;
@property (nonatomic, strong) NSMutableArray *sortArray;


@property (weak, nonatomic) IBOutlet UILabel *sortArrayLabel;
@property (weak, nonatomic) IBOutlet UIButton *sortByButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UITableView *fieldsTable;

@end
