//
//  HADHourMinuteSecondPicker.m
//  Competition Tracker
//
//  Created by Heather Dyson on 8/7/18.
//  Copyright © 2018 Heather Dyson. All rights reserved.
//

#import "HADHourMinuteSecondPicker.h"

@implementation HADHourMinuteSecondPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init {
    self = [super init];
    [self initialize];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self initialize];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initialize];
    return self;
}

-(void) initialize {
    self.delegate = self;
    self.dataSource = self;
    
    int height = 20;
    int offsetX = self.frame.size.width / 3;
    int offsetY = self.frame.size.height / 2 - height / 2;
    int marginX = 42;
    int width = offsetX - marginX;
    
    UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, offsetY, width, height)];
    hourLabel.text = @"H";
    [self addSubview:hourLabel];
    
    UILabel *minsLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX + offsetX, offsetY, width, height)];
    minsLabel.text = @"M";
    [self addSubview:minsLabel];
    UILabel *secsLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX + offsetX * 2, offsetY, width, height)];
    secsLabel.text = @"S";
    [self addSubview:secsLabel];
    [self selectRow:24 inComponent:0 animated:NO];
    [self selectRow:60 inComponent:1 animated:NO];
    [self selectRow:60 inComponent:2 animated:NO];
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.hours = row%24;
        [self selectRow:self.hours+24 inComponent:0 animated:NO];
    } else if (component == 1) {
        self.mins = row%60;
        [self selectRow:self.mins+60 inComponent:1 animated:NO];
    } else if (component == 2) {
        self.secs = row%60;
        [self selectRow:self.secs+60 inComponent:2 animated:NO];
    }
}

-(NSInteger)getPickerTimeInMS {
    return (self.hours * 60 * 60 + self.mins * 60 + self.secs) * 1000;
}

-(NSInteger)getPickerTimeInS {
    return (self.hours * 60 * 60 + self.mins * 60 + self.secs);
}

- (void)setSelectionFromSeconds:(NSInteger)seconds{
    NSInteger h = (seconds % 86400) / 3600;
    NSInteger m = (seconds % 3600) / 60;
    NSInteger s = (seconds % 60);
    
    self.hours = h;
    self.mins = m;
    self.secs = s;
    
    [self selectRow:h+24 inComponent:0 animated:NO];
    [self selectRow:m+60 inComponent:1 animated:NO];
    [self selectRow:s+60 inComponent:2 animated:NO];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return 24*3;
    
    return 60*3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    int mod;
    if(component == 0)
        mod = 24;
    else
        mod = 60;
    
    if (view != nil) {
        ((UILabel*)view).text = [NSString stringWithFormat:@"%lu", row%mod];
        return view;
    }
    UILabel *columnView = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.frame.size.width/3 - 35, 30)];
    columnView.text = [NSString stringWithFormat:@"%lu", row%mod];
    columnView.textAlignment = NSTextAlignmentLeft;
    
    return columnView;
}

@end
