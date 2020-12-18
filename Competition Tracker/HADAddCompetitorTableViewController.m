//
//  HADAddCompetitorTableViewController.m
//  Competition Tracker
//
//  Created by Heather Dyson on 8/2/18.
//  Copyright © 2018 Heather Dyson. All rights reserved.
//

#import "HADAddCompetitorTableViewController.h"

@interface HADAddCompetitorTableViewController ()
{
    bool scoreInTime;
}
@end

@implementation HADAddCompetitorTableViewController
@synthesize rankingViewController;
@synthesize fields;
@synthesize fieldValDictionary; // dictionary of UITextFields
@synthesize thisCompetitor; //competitor for editMode

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fieldValDictionary = [[NSMutableDictionary alloc] init];
    if ([rankingViewController editMode])
        thisCompetitor = [[rankingViewController competitorsArray] objectAtIndex:[rankingViewController editIndex]];
    scoreInTime = [[[rankingViewController competitionDictionary] objectForKey:kHADScoreUnits] isEqualToString:@"Time"];

    
    //fields = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [fields count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Competitor Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 90, 30)];
    bool scoreField = [[fields objectAtIndex:[indexPath row]] isEqualToString:kHADCompetitorScore];
    
    [cellLabel setText:[[fields objectAtIndex:[indexPath row]] stringByAppendingString:@":"]];
    [cellLabel setTextAlignment:NSTextAlignmentRight];
    [cell addSubview:cellLabel];

    if (scoreField && scoreInTime){
        HADHourMinuteSecondPicker *timeScore = [[HADHourMinuteSecondPicker alloc] initWithFrame:CGRectMake(110, 7, 250, 37)];
        if([rankingViewController editMode]){
            NSString *seconds = [thisCompetitor objectForKey:[fields objectAtIndex:[indexPath row]]];
            [timeScore setSelectionFromSeconds:[seconds integerValue]];
        }
        [timeScore setBackgroundColor:[UIColor whiteColor]];
        [cell addSubview:timeScore];
        [fieldValDictionary setObject:timeScore forKey:[fields objectAtIndex:[indexPath row]]];
    } else {
        UITextField *cellTextField =  [[UITextField alloc] initWithFrame:CGRectMake(110, 13, 300, 30)];
        if([rankingViewController editMode]){
            cellTextField.text = [thisCompetitor objectForKey:[fields objectAtIndex:[indexPath row]]];
        }
        cellTextField.placeholder = [fields objectAtIndex:[indexPath row]];
        if(scoreField){
            cellTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        [cellTextField setBackgroundColor:[UIColor whiteColor]];
        [cell addSubview:cellTextField];
        [fieldValDictionary setObject:cellTextField forKey:[fields objectAtIndex:[indexPath row]]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelButtonSelected:(id)sender {
    [rankingViewController setEditMode:false];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonSelected:(id)sender {
    
    NSMutableDictionary *newCompetitor;
    bool isEditing = [rankingViewController editMode];
    if(!isEditing){
        newCompetitor = [[NSMutableDictionary alloc] init];
    }
    UITextField *textField;
    UITextField *nameVal =[fieldValDictionary objectForKey:kHADCompetitorName];
    UITextField *scoreVal;
    HADHourMinuteSecondPicker *scoreValTime;
    if(scoreInTime){
        scoreValTime = [fieldValDictionary objectForKey:kHADCompetitorScore];
    }else {
        scoreVal = [fieldValDictionary objectForKey:kHADCompetitorScore];
    }
    bool noName = false;
    bool noScore = false;
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    if(!([nameVal hasText]) || (([allTrim([nameVal text]) length]) == 0)){
        noName = true;
    }
    if (!scoreInTime){
        if (!([scoreVal hasText]) || (([allTrim([scoreVal text]) length]) == 0)){
            noScore = true;
        }
    }
    
    if( noName || noScore) {
        [self alertMessage:@"Enter Data" informUser:@"Competitor must have a name and score."];
        if(noName) [nameVal setText:@""];
        if (noScore) [scoreVal setText:@""];
    } else if(!(scoreInTime) && ([nf numberFromString:[scoreVal text]] == nil)){
        [self alertMessage:@"Error" informUser:@"Score must be a number."];
        [scoreVal setText:@""];
    } else {
        for(int i=0; i<[fields count]; i++){
            NSString *currentField = [fields objectAtIndex:i];
            NSString *newVal;
            if([currentField isEqualToString:kHADCompetitorScore] && scoreInTime){
                newVal = [NSString stringWithFormat: @"%ld", [scoreValTime getPickerTimeInS]];
            }else {
                textField = [fieldValDictionary objectForKey:currentField];
                newVal = [textField text];
            }
            if(isEditing){
                [thisCompetitor setObject:allTrim(newVal) forKey:currentField];
            }else{
                [newCompetitor setObject:allTrim(newVal) forKey:currentField];
            }
        }
        if(isEditing){
            [rankingViewController editCompetitor];
        } else {
            [rankingViewController addCompetitor:newCompetitor];
        }
    
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) alertMessage:(NSString *)title informUser:(NSString *)info {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:info
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
