//
//  TimeLineViewController.m
//  alhanove
//
//  Created by GALMarei on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "TimeLineViewController.h"
#import "TwoLineCell.h"
#import "FourLineCell.h"
#import "TotalCell.h"

@interface TimeLineViewController ()
{
    NSMutableArray* timelineDataArr;
    NSMutableArray* sectionDates;
}
@end

@implementation TimeLineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.pageTitle setFont:[UIFont mediumGeSSOfSize:20]];

    //get the data for the timeline
    [self getTimeLineData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods
-(void)getTimeLineData
{
    /*
    timelineDataArr = [NSMutableArray new];
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/05/28";
    NSDictionary *MenuDict = @{@"Title" : @"بداية الرحلة",
                               @"Text" : @"الإنطلاق من نقطة التجمع",
                               @"Type" : @"step_1"};
    NSMutableArray* menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
    MenuDict = nil;
    dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/05/29";
    MenuDict = @{@"Title" : @"حجز بالفندق",
                               @"Text" : self.formObj.MekkaHotelData[@"Title"],
                               @"Type" : @"step_2"};
    menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
    MenuDict = nil;
    dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/05/30";
    MenuDict = @{@"Title" : @"وجبة غذاء",
                               @"Text" : self.formObj.MekkaHotelData[@"Title"],
                               @"Type" : @"step_2"};
    menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
    MenuDict = nil;
    dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/05/31";
    MenuDict = @{@"Title" : @"بدئ العمرة",
                 @"Text" : @"الذهاب إلى الحرم",
                 @"Type" : @"step_1"};
    menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
    MenuDict = nil;
    dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/06/03";
    MenuDict = @{@"Title" : @"حجز بالفندق",
                 @"Text" : self.formObj.MadinaHotelData[@"Title"],
                 @"Type" : @"step_2"};
    menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
    MenuDict = nil;
    dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/06/06";
    MenuDict = @{@"Title" : @"نهاية الرحلة",
                 @"Text" : @"تجهيز الاغراض والاستعداد للعودة",
                 @"Type" : @"step_3"};
    menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    */
    timelineDataArr = [NSMutableArray new];
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/05/28";
    NSDictionary *MenuDict = @{@"Title" :@"حجز عمرة",
                               @"Text" : @"نص قصير حول هذه الخطوة",
                               @"Type" : @"step_1"};
    
    NSMutableArray* menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
    MenuDict = nil;
    dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/05/29";
    MenuDict = @{@"Title" : @"تفاصيل الحجز",
                 @"guestsNumber" : [NSNumber numberWithInt:self.formObj.guestsNumber],
                 @"roomsNumber" : [NSNumber numberWithInt: self.formObj.roomsNumber],
                 @"date" : self.formObj.fromDate,
                 @"Type" : @"step_2"};
    menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
    
    MenuDict = nil;
    dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/05/30";
    MenuDict = @{@"Title" : @"فندق مكة المكرمة",
                 @"Text" : self.formObj.MekkaHotelData[@"Title"],
                 @"Price": self.formObj.MekkaHotelData[@"Cost_all"],
                 @"Type" : @"step_3"};
    menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
    MenuDict = nil;
    dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/06/06";
    MenuDict = @{@"Title" : @"فندق المدينة المنورة",
                 @"Text" : self.formObj.MekkaHotelData[@"Title"],
                 @"Price": self.formObj.MekkaHotelData[@"Cost_all"],
                 @"Type" : @"step_4"};
    menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    [timelineDataArr addObject:MenuDict];
    
    [self.tableView reloadData];

}


#pragma mark - IBAction
- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextInvoked:(id)sender {
    [self performSegueWithIdentifier:@"showUserForm" sender:self];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [timelineDataArr count];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* dict = [timelineDataArr objectAtIndex:section];
    NSArray* arr = dict[@"data"];
    return [arr count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary* dict = [timelineDataArr objectAtIndex:indexPath.section];
    NSArray* arr = dict[@"data"];
    NSDictionary* rowDictionary = [arr objectAtIndex:indexPath.row];
    
    if ([rowDictionary[@"Type"] isEqualToString:@"step_1"]) {
        return 50.0;
    }
    else if ([rowDictionary[@"Type"] isEqualToString:@"step_2"]) {
        return 100.0;
    }
    else if ([rowDictionary[@"Type"] isEqualToString:@"step_3"]) {
        return 50.0;
    }
    else if ([rowDictionary[@"Type"] isEqualToString:@"step_4"]) {
        return 50.0;
    }
    else
        return 50.0;


}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary* dictionaryArray = [timelineDataArr objectAtIndex:section];
    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [lbl setTextAlignment:NSTextAlignmentRight];
    [lbl setText:dictionaryArray[@"sectionDate"]];
    
    return lbl;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    NSDictionary* dict = [timelineDataArr objectAtIndex:indexPath.section];
    NSArray* arr = dict[@"data"];
    NSDictionary* rowDictionary = [arr objectAtIndex:indexPath.row];

    if ([rowDictionary[@"Type"] isEqualToString:@"step_1"]) {
        TwoLineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[TwoLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSArray* topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TwoLineCell" owner:self options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];
        
        if (cell == nil) {
            cell = [[TwoLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.iconImg setImage:[UIImage imageNamed:rowDictionary[@"Type"]]];
            cell.titleLabel.text = rowDictionary[@"Title"];
            [cell.titleLabel setFont:[UIFont mediumGeSSOfSize:12]];
            cell.subtitleLabel.text=rowDictionary[@"Text"];
            [cell.subtitleLabel setFont:[UIFont lightGeSSOfSize:12]];
            
        }
        return cell;
        
    }
    else if ([rowDictionary[@"Type"] isEqualToString:@"step_2"]) {
        FourLineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[FourLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSArray* topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FourLineCell" owner:self options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];
        
        if (cell == nil) {
            cell = [[FourLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            // TODO : font
            [cell.iconImg setImage:[UIImage imageNamed:rowDictionary[@"Type"]]];
            cell.detailsLabel.text = rowDictionary[@"Title"];
            cell.guestsNumLabel.text=rowDictionary[@"guestsNumber"];
            cell.roomsNumLabel.text=rowDictionary[@"roomsNumber"];
            cell.dateLabel.text=rowDictionary[@"date"];
            
        }
        return cell;
        
    }
    else if ([rowDictionary[@"Type"] isEqualToString:@"step_3"]) {
        TwoLineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[TwoLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSArray* topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TwoLineCell" owner:self options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];

        
        if (cell == nil) {
            // TODO : icon & font
            [cell.iconImg setImage:[UIImage imageNamed:rowDictionary[@"Type"]]];
            cell.titleLabel.text = rowDictionary[@"Title"];
            cell.subtitleLabel.text=rowDictionary[@"Text"];
            cell.priceLabel.text=rowDictionary[@"Price"];
            cell.priceLabel.hidden=NO;
            
        }
        return cell;
        
    }
    else if ([rowDictionary[@"Type"] isEqualToString:@"step_4"]) {
        TwoLineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[TwoLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSArray* topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TwoLineCell" owner:self options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];

        
        if (cell == nil) {
            // TODO : icon and font
            [cell.iconImg setImage:[UIImage imageNamed:rowDictionary[@"Type"]]];
            cell.titleLabel.text = rowDictionary[@"Title"];
            cell.subtitleLabel.text=rowDictionary[@"Text"];
            cell.priceLabel.text=rowDictionary[@"Price"];
            cell.priceLabel.hidden=NO;
            
        }
        return cell;
        
    }
    else{
        TotalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[TotalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSArray* topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TotalCell" owner:self options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];
        
        if (cell == nil) {
            cell = [[TotalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        // TODO : clac total price
        cell.totalNumberLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%li ريال",[self.formObj.BookingCost integerValue] + [self.formObj.FlightCost integerValue]]];
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showUserForm"])   //parameter to login page
    {
        TimeLineViewController* vc = segue.destinationViewController;
        vc.formObj = self.formObj;
    }
}


@end
