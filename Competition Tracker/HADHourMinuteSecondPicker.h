//
//  HADHourMinuteSecondPicker.h
//  Competition Tracker
//
//  Created by Heather Dyson on 8/7/18.
//  Copyright © 2018 Heather Dyson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HADHourMinuteSecondPicker : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property NSInteger hours;
@property NSInteger mins;
@property NSInteger secs;

-(NSInteger) getPickerTimeInMS;
-(NSInteger) getPickerTimeInS;
- (void)setSelectionFromSeconds:(NSInteger)seconds;
-(void) initialize;


@end
