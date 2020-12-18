//
//  HADCompTableViewController.h
//  
//
//  Created by Heather Dyson on 7/26/18.
//

#import <UIKit/UIKit.h>

#define kHADCompName @"compName"
#define kHADScoreUnits @"scoreUnits"
#define kHADOtherVal @"otherVal"
#define kHADBestScore @"bestScore"
#define kHADCompetitorArray @"compArray"
#define kHADFieldOrder @"compDictKeys"
#define kHADPrimarySort @"primarySort"
#define kHADSecondarySort @"secondarySort"
#define kHADSortArray @"sortArray"
#define kHADShowFields @"showFields"

#define kHADCompetitorName @"Name"
#define kHADCompetitorScore @"Score"

@interface HADCompTableViewController : UITableViewController

- (void) addCompetition: (NSMutableDictionary *) newCompetition;
- (void) editCompetition;

@property NSMutableArray *competitionArray;
@property NSMutableDictionary *competitorDictionary;
@property bool isEditing;
@property NSInteger currentRow;


@end
