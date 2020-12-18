//
//  HADRankingsTableViewController.m
//  Competition Tracker
//
//  Created by Heather Dyson on 8/2/18.
//  Copyright © 2018 Heather Dyson. All rights reserved.
//

#import "HADRankingsTableViewController.h"
#import "HADAddCompetitorTableViewController.h"
#import "HADOrganizeViewController.h"

@interface HADRankingsTableViewController ()

@end

@implementation HADRankingsTableViewController
@synthesize competitionTableViewController;
@synthesize competitionDictionary;
@synthesize competitorsArray;
@synthesize displayArray;
@synthesize competitorFields;
@synthesize navBar;
@synthesize editMode;
@synthesize editIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [navBar setPrompt:[competitionDictionary objectForKey:kHADCompName]];
    
    competitorsArray = [competitionDictionary objectForKey:kHADCompetitorArray];
    if(competitorsArray == NULL){
        competitorsArray = [[NSMutableArray alloc] init];
        [competitionDictionary setObject:competitorsArray forKey:kHADCompetitorArray];
        NSLog(@"initializing array");
    }
        
    [self sortCompetitors];
    editMode = false;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)sortCompetitors{
    NSSortDescriptor *descriptor;
    NSMutableArray *descriptorArray = [[NSMutableArray alloc] init];
    BOOL asc = YES;
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    if([[competitionDictionary objectForKey:kHADSortArray] count] !=0){
        NSMutableArray *theSortArray = [competitionDictionary objectForKey:kHADSortArray];
        for(int i=0; i<[theSortArray count]; i++){
            NSString *sortVal = [theSortArray objectAtIndex:i];
            if(([sortVal isEqualToString:kHADCompetitorScore]) &&
               ([[competitionDictionary objectForKey:kHADBestScore] isEqualToString:@"High"]))
                asc = NO;
            else
                asc = YES;
            descriptor = [[NSSortDescriptor alloc] initWithKey:sortVal ascending:asc comparator:^(id obj1, id obj2){
                //NSLog(@"obj1 = %f obj2 = %f", [obj1 doubleValue], [obj2 doubleValue]);
                if(([nf numberFromString:obj1] != NULL) && ([nf numberFromString:obj2] != NULL)){
                    if ([obj1 doubleValue] > [obj2 doubleValue]) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    if ([obj1 doubleValue] < [obj2 doubleValue]) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    return (NSComparisonResult)NSOrderedSame;
                } else {
                    return [(NSString *)obj1 compare:(NSString *)obj2];
                }
            }];
            [descriptorArray addObject:descriptor];
        }
        displayArray = [competitorsArray sortedArrayUsingDescriptors:descriptorArray];
    } else {
        displayArray = [competitorsArray copy];
    }
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [displayArray count]+1;
}
/*
- (NSString *)timeFormatted:(NSString *)totalSeconds {
    
    NSInteger seconds = [totalSeconds integerValue] % 60;
    NSInteger minutes = ([totalSeconds integerValue] / 60) % 60;
    NSInteger hours = [totalSeconds integerValue] / 3600;
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hours, minutes, seconds];
}
*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Rank Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    if([indexPath row] == 0){
        NSString *score = @"Score";
        NSString *scoreUnits = [competitionDictionary objectForKey:kHADScoreUnits];
        if([scoreUnits isEqualToString:@"Other"] &&
           ([competitionDictionary objectForKey:kHADOtherVal] != NULL))
            scoreUnits = [competitionDictionary objectForKey:kHADOtherVal];
        if(![scoreUnits isEqualToString:@"Other"] && ![scoreUnits isEqualToString:@"Points"]
           && ![scoreUnits isEqualToString:@""]){
            if([scoreUnits isEqualToString:@"Time"])
                score = [score stringByAppendingString:@" (HH:MM:SS)"];
            else
                score = [score stringByAppendingFormat:@" (in %@)", scoreUnits];
        }
        [[cell textLabel] setText:@"Name"];
        [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:20]];
        [[cell detailTextLabel] setText:score];
        [[cell detailTextLabel] setFont:[UIFont boldSystemFontOfSize:20]];
    } else {
        NSMutableDictionary *dict = [displayArray objectAtIndex:[indexPath row]-1];
        NSString *infoText = [dict objectForKey:kHADCompetitorName];
        if(([competitionDictionary objectForKey:kHADShowFields]) &&
           ([[competitionDictionary objectForKey:kHADShowFields] count] > 0)){
            NSMutableArray *extraInfo = [competitionDictionary objectForKey:kHADShowFields];
            NSString *info;
            for(int i=0; i<[extraInfo count]; i++){
                info = [dict objectForKey:[extraInfo objectAtIndex:i]];
                if(info == NULL) info = @"";
                infoText = [infoText stringByAppendingFormat:@"\n%@: %@", [extraInfo objectAtIndex:i], info];
            }
        //infoText = [infoText stringByAppendingString:@"\nThis is a test"];
            [[cell textLabel] setNumberOfLines:[extraInfo count]+1];
        }
        [[cell textLabel] setText:infoText];
        if([[competitionDictionary objectForKey:kHADScoreUnits] isEqualToString:@"Time"]){
            NSString *totalSeconds = [dict objectForKey:kHADCompetitorScore];
            NSInteger seconds = [totalSeconds integerValue] % 60;
            NSInteger minutes = ([totalSeconds integerValue] / 60) % 60;
            NSInteger hours = [totalSeconds integerValue] / 3600;
            
            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%02ld:%02ld:%02ld",hours, minutes, seconds]];

        } else {
            [[cell detailTextLabel] setText:[dict objectForKey:kHADCompetitorScore]];
        }
        [[cell textLabel] setFont:[UIFont systemFontOfSize:17]];
        [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:17]];

        //[[cell imageView] setImage:[UIImage imageNamed:@"small_plus.png"]];
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] != 0){
        NSInteger compRow = [indexPath row]-1;
        NSMutableDictionary *rowDict = [displayArray objectAtIndex:compRow];
        
        for(int i = 0; i<[competitorsArray count]; i++){
            if([rowDict isEqualToDictionary:[competitorsArray objectAtIndex:i]]){
                editIndex = i;
                break;
            }
        }
  
        UITableViewRowAction *editAction = [UITableViewRowAction    rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your editAction here
        //NSLog(@"Editing");
            self.editMode = true;
            [self performSegueWithIdentifier:@"AddCompetitorSegue" sender:self];
        }];
        editAction.backgroundColor = [UIColor lightGrayColor];
    
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your deleteAction here
        //NSLog(@"Deleting");
            [self.competitorsArray removeObjectAtIndex:self.editIndex];
            [self sortCompetitors];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        }];
        deleteAction.backgroundColor = [UIColor redColor];
        return @[deleteAction,editAction];
    } else {
        return @[];
    }
}



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ( [[segue identifier] isEqualToString:@"AddCompetitorSegue"]){
        UINavigationController *navController = [segue destinationViewController];
        HADAddCompetitorTableViewController *addCVC = (HADAddCompetitorTableViewController*)[navController visibleViewController];
        [addCVC setRankingViewController:self];
        [addCVC setFields:[competitionDictionary objectForKey:kHADFieldOrder]];
    } else if([[segue identifier] isEqualToString:@"ViewCompetitorSegue"]){
        ViewController *detailVC = [segue destinationViewController];
        NSIndexPath *selectedRow = [[self tableView] indexPathForSelectedRow];
        NSInteger theRow = [selectedRow row];
        if(theRow == 0){
           return;
        }
        NSMutableDictionary *competitorRow = [displayArray objectAtIndex:theRow-1];
        NSMutableString *myString = [[NSMutableString alloc] init];
        
        for(int i=0; i<[[competitionDictionary objectForKey:kHADFieldOrder] count]; i++){
            NSString *key = [[competitionDictionary objectForKey:kHADFieldOrder] objectAtIndex:i];
            NSString *obj = [competitorRow objectForKey:key];
            if([key isEqualToString:@"Score"] && [[competitionDictionary objectForKey:kHADScoreUnits] isEqualToString:@"Time"]){
                NSInteger seconds = [obj integerValue] % 60;
                NSInteger minutes = ([obj integerValue] / 60) % 60;
                NSInteger hours = [obj integerValue] / 3600;
                
                obj = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hours, minutes, seconds];
            }
            if(obj == NULL) obj = @"";
            [myString appendFormat:@"%@ : %@\n\n", key, obj];
        }

        //NSLog(myString);
        [detailVC setInfoText:myString];
        [detailVC setInfoLines:[[competitionDictionary objectForKey:kHADFieldOrder] count]*3];
    }else if([[segue identifier] isEqualToString:@"OrganizeSegue"]){
        HADOrganizeViewController *organizeVC = [segue destinationViewController];
        [organizeVC setRankingTVC:self];
    }

}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([identifier isEqualToString:@"ViewCompetitorSegue"]){
        NSIndexPath *selectedRow = [[self tableView] indexPathForSelectedRow];
        NSInteger theRow = [selectedRow row];
        if(theRow == 0){
            return false;
        }
    }
    return true;
}

- (void) addCompetitor: (NSMutableDictionary *) newCompetitor {
    [competitorsArray addObject:newCompetitor];
    [self sortCompetitors];
    [[self tableView] reloadData];
}

- (void) editCompetitor {
    editMode = false;
    [self sortCompetitors];
    [[self tableView] reloadData];
}


- (IBAction)backButtonPressed:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionButtonPressed:(id)sender {
    NSString *textToShare = @"\nCurrent Rankings For ";
    textToShare = [textToShare stringByAppendingFormat:@"%@ Competition", [competitionDictionary objectForKey:kHADCompName]];

    for(int i=0; i<[displayArray count]; i++){
        NSMutableDictionary *currentCompetitor = [displayArray objectAtIndex:i];
        textToShare = [textToShare stringByAppendingFormat:@"\n%@\t%@",
                       [currentCompetitor objectForKey:kHADCompetitorName],
                       [currentCompetitor objectForKey:kHADCompetitorScore]];
        if([[competitionDictionary objectForKey:kHADShowFields] count] > 0){
            for(int j=0; j<[[competitionDictionary objectForKey:kHADShowFields] count]; j++){
                textToShare = [textToShare stringByAppendingFormat:@"\n%@: %@",
                               [[competitionDictionary objectForKey:kHADShowFields] objectAtIndex:j],
                               [currentCompetitor objectForKey:[[competitionDictionary objectForKey:kHADShowFields] objectAtIndex:j]]];
            }
        }
     }
    NSLog(@"%@", textToShare);
    //NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
    
    NSArray *objectsToShare = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   //UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}
@end
