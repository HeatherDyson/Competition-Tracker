//
//  HADCompTableViewController.m
//  
//
//  Created by Heather Dyson on 7/26/18.
//

#import "HADCompTableViewController.h"
#import "HADAddCompTableViewController.h"
#import "HADRankingsTableViewController.h"

@interface HADCompTableViewController ()

@end

@implementation HADCompTableViewController
@synthesize competitionArray;
@synthesize competitorDictionary;
@synthesize isEditing;
@synthesize currentRow;

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    isEditing = false;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveData:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self plistPath]]){
        competitionArray = [[NSMutableArray alloc] initWithContentsOfFile:[self plistPath]];
    } else {
        competitionArray = [[NSMutableArray alloc] init];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSString *)plistPath{
    NSString *homeDir = NSHomeDirectory();
    NSString *filePath = [homeDir stringByAppendingString:@"/Documents/competitionsList.plist"];
    return filePath;
}

- (void) saveData: (NSNotification *)notification{
    NSString *filePath;
    filePath = [self plistPath];
    [competitionArray writeToFile:filePath atomically:YES];
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
    return [competitionArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSUInteger rowNumber = [indexPath row];
    NSDictionary *compDictionary = [competitionArray objectAtIndex:rowNumber];
    NSString *competition = [compDictionary objectForKey:kHADCompName];
    
    [[cell textLabel] setText:competition];

    
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
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your editAction here
        //NSLog(@"Editing");
        
        self.currentRow = [indexPath row];
        self.isEditing = true;
        [self performSegueWithIdentifier:@"AddCompetitionSegue" sender:self];
    }];
    editAction.backgroundColor = [UIColor lightGrayColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your deleteAction here
        //NSLog(@"Deleting");
        [self.competitionArray removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction,editAction];
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
    if ( [[segue identifier] isEqualToString:@"AddCompetitionSegue"]){
        UINavigationController *navController = [segue destinationViewController];
        HADAddCompTableViewController *addCVC = (HADAddCompTableViewController*)[navController visibleViewController];
        [addCVC setCompetitionTableViewController:self];
    }
    else if([[segue identifier] isEqualToString:@"RankingsSegue"]){
        UINavigationController *navController = [segue destinationViewController];
        [navController setToolbarHidden:NO];
        HADRankingsTableViewController *rankingCVC = (HADRankingsTableViewController*)[navController visibleViewController];
        [rankingCVC setCompetitionTableViewController:self];
        
        NSIndexPath *selectedRow = [[self tableView] indexPathForSelectedRow];
        NSMutableDictionary *currentCompetition = [competitionArray objectAtIndex:[selectedRow row]];
        [rankingCVC setCompetitionDictionary:currentCompetition];

    }
    // Pass the selected object to the new view controller.
}


- (void) addCompetition: (NSMutableDictionary *)newCompetition{
    [competitionArray addObject:newCompetition];
    [[self tableView] reloadData];
}

- (void) editCompetition{
    isEditing = false;
    [[self tableView] reloadData];
}

@end
