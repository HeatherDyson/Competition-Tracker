//
//  HADOrganizeViewController.m
//  Competition Tracker
//
//  Created by Heather Dyson on 8/4/18.
//  Copyright © 2018 Heather Dyson. All rights reserved.
//

#import "HADOrganizeViewController.h"

@interface HADOrganizeViewController ()
{
    NSMutableArray *showArray;
}
@end

@implementation HADOrganizeViewController
@synthesize rankingTVC;
@synthesize sortArrayLabel;
@synthesize sortByButton;
@synthesize removeButton;
@synthesize clearButton;
@synthesize showLabel;
@synthesize fieldsTable;
@synthesize sortArray;
@synthesize fieldArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fieldArray = [[self.rankingTVC competitionDictionary] objectForKey:kHADFieldOrder];
    if([fieldArray count] == 2){
        showLabel.hidden = true;
        fieldsTable.hidden = true;
    }
    
    sortArray = [[rankingTVC competitionDictionary] objectForKey:kHADSortArray];
    if(sortArray == NULL){
        sortArray = [[NSMutableArray alloc] init];
        [[rankingTVC competitionDictionary] setObject:sortArray forKey:kHADSortArray];
        [sortByButton setTitle:@"Sort By..." forState:UIControlStateNormal];
        [removeButton setUserInteractionEnabled:NO];
        [clearButton setUserInteractionEnabled:NO];
        [sortArrayLabel setText:@""];
    } else {
        if ([sortArray count] > 0)
            [sortByButton setTitle:@"Then By..." forState:UIControlStateNormal];
        else
            [sortByButton setTitle:@"Sort By..." forState:UIControlStateNormal];
        [removeButton setUserInteractionEnabled:YES];
        [clearButton setUserInteractionEnabled:YES];
        [sortArrayLabel setText:[sortArray componentsJoinedByString:@", "]];
    }
    
    showArray = [[rankingTVC competitionDictionary] objectForKey:kHADShowFields];
    if(showArray == NULL){
        showArray = [[NSMutableArray alloc] init];
        [[rankingTVC competitionDictionary] setObject:showArray forKey:kHADShowFields];
    }

    fieldsTable.dataSource = self;
    fieldsTable.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[rankingTVC competitionDictionary] setObject:sortArray forKey:kHADSortArray];
    [rankingTVC editCompetitor]; //using method to update view, as that's all it does
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [fieldArray count]-2;//number rows you want in table
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Display Field Cell" forIndexPath:indexPath];
    UILabel * myLabel = (UILabel *)[cell viewWithTag:100];
    UISwitch *mySwitch = (UISwitch *)[cell viewWithTag:101];
    
    myLabel.text = [fieldArray objectAtIndex:indexPath.row+2];

    if([showArray containsObject:[myLabel text]])
        [mySwitch setOn:YES];
    [mySwitch addTarget:self action:@selector(flipField:) forControlEvents:UIControlEventValueChanged];
    //[mySwitch action]
    

    // Configure the cell...
    return cell;
}

- (IBAction)flipField:(id)sender{
    //NSLog(@"Switch Flipped");
    NSString *fieldName;
    UITableViewCell *thisCell = (UITableViewCell *)[sender superview];
    UILabel *thisCellLabel = (UILabel *)[thisCell viewWithTag:100];

    fieldName = [thisCellLabel text];
    if([(UISwitch *)sender isOn])
        [showArray addObject:fieldName];
    else
        [showArray removeObject:fieldName];
    //NSLog(@"fieldName = %@", fieldName);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1; //by default is 1
}


- (IBAction)sortButtonPressed:(id)sender {
    NSString *msg = @"Which field would you like to add to the sort?";
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Add Sort Field" message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    
    for(int i=0; i<[fieldArray count]; i++){
        NSString *fieldTitle = [fieldArray objectAtIndex:i];
        if (!([sortArray containsObject:fieldTitle])){
            [actionSheet addAction:[UIAlertAction actionWithTitle:fieldTitle    style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
                NSLog(@"adding %@", [action title]);
                [[self sortArray] addObject:fieldTitle];
                
                [[self sortByButton] setTitle:@"Then By..." forState:UIControlStateNormal];
                [[self removeButton] setUserInteractionEnabled:YES];
                [[self clearButton] setUserInteractionEnabled:YES];
                [[self sortArrayLabel] setText:[[self sortArray] componentsJoinedByString:@", "]];
           }]];
        }
    }
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    


}

- (IBAction)removeSortFieldButtonPressed:(id)sender {
    if([sortArray count] > 0){
        NSString *msg = @"Which sort field would you like to delete?";
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Delete Field" message:msg preferredStyle:UIAlertControllerStyleActionSheet];
        
        for(int i=0; i<[sortArray count]; i++){
            NSString *sortFieldTitle = [sortArray objectAtIndex:i];
            [actionSheet addAction:[UIAlertAction actionWithTitle:sortFieldTitle    style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSLog(@"Deleting %@", [action title]);
                [[self sortArray] removeObjectAtIndex:i];
                if([[self sortArray] count] == 0){
                    [[self sortByButton] setTitle:@"Sort By..." forState:UIControlStateNormal];
                    [[self removeButton] setUserInteractionEnabled:NO];
                    [[self clearButton] setUserInteractionEnabled:NO];
                    [[self sortArrayLabel] setText:@""];
                } else {
                    [[self sortArrayLabel] setText:[[self sortArray] componentsJoinedByString:@", "]];
                }

            }]];
            
        }
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

- (IBAction)clearSortButtonPressed:(id)sender {
    [sortByButton setTitle:@"Sort By..." forState:UIControlStateNormal];
    [removeButton setUserInteractionEnabled:NO];
    [clearButton setUserInteractionEnabled:NO];
    [sortArray removeAllObjects];
    [sortArrayLabel setText:@""];
}


@end
